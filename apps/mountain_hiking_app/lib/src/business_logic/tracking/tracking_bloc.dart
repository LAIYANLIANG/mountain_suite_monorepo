import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpx/gpx.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_library/gpx_library_bloc.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;

part 'tracking_event.dart';
part 'tracking_state.dart';

/// V1.0 - 軌跡記錄功能的業務邏輯核心 (BLoC)。
///
/// 負責處理權限請求、GPS 位置監聽、軌跡點收集與儲存。
class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final GpxLibraryBloc _gpxLibraryBloc;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _timer;

  TrackingBloc({required GpxLibraryBloc gpxLibraryBloc})
      : _gpxLibraryBloc = gpxLibraryBloc,
        super(const TrackingState()) {
    on<PermissionRequested>(_onPermissionRequested);
    on<GpxFileLoaded>(_onGpxFileLoaded);
    on<TrackingStarted>(_onTrackingStarted);
    on<TrackingPaused>(_onTrackingPaused);
    on<TrackingResumed>(_onTrackingResumed);
    on<TrackingStopped>(_onTrackingStopped);
    on<TrackSaved>(_onTrackSaved);
    on<_PositionUpdated>(_onPositionUpdated);
    on<_TimerTicked>(_onTimerTicked);

    // BLoC 初始化時立即請求權限
    add(PermissionRequested());
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _timer?.cancel();
    return super.close();
  }

  /// 處理 [PermissionRequested] 事件：檢查並請求定位權限。
  Future<void> _onPermissionRequested(
    PermissionRequested event,
    Emitter<TrackingState> emit,
  ) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(state.copyWith(
        status: TrackingStatus.error,
        errorMessage: '請開啟您裝置的 GPS 定位服務。',
      ));
      return;
    }

    var permission = await perm_handler.Permission.location.status;
    if (permission.isDenied) {
      permission = await perm_handler.Permission.location.request();
    }

    if (permission.isGranted) {
      emit(state.copyWith(status: TrackingStatus.ready));
    } else {
      emit(state.copyWith(status: TrackingStatus.permissionDenied));
    }
  }

  /// 處理 [GpxFileLoaded] 事件：載入 GPX 檔案作為參考路線。
  Future<void> _onGpxFileLoaded(
    GpxFileLoaded event,
    Emitter<TrackingState> emit,
  ) async {
    try {
      final fileContent = await File(event.filePath).readAsString();
      final gpx = GpxReader().fromString(fileContent);
      final points = gpx.trks
          .expand((trk) => trk.trksegs)
          .expand((seg) => seg.trkpts)
          .map((pt) => LatLng(pt.lat!, pt.lon!))
          .toList();

      final polyline = Polyline(
        polylineId: PolylineId(event.filePath),
        points: points,
        color: Colors.red, // 參考路線為紅色
        width: 5,
      );

      emit(state.copyWith(referencePolylines: {polyline}));
    } catch (e) {
      emit(state.copyWith(
        status: TrackingStatus.error,
        errorMessage: '讀取參考軌跡失敗: ${e.toString()}',
      ));
    }
  }

  /// 處理 [TrackingStarted] 事件：開始記錄軌跡。
  void _onTrackingStarted(TrackingStarted event, Emitter<TrackingState> emit) {
    if (state.status != TrackingStatus.ready && state.status != TrackingStatus.stopped) return;

    _startTimer();

    _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 每 10 公尺更新一次
      ),
    ).listen((position) {
      add(_PositionUpdated(position));
    });

    emit(state.copyWith(
      status: TrackingStatus.recording,
      liveTrackPoints: [],
      duration: Duration.zero,
    ));
  }

  /// 處理 [_PositionUpdated] 事件：更新 GPS 位置並加入軌跡點。
  void _onPositionUpdated(_PositionUpdated event, Emitter<TrackingState> emit) {
    if (state.status == TrackingStatus.recording) {
      final updatedPoints = List<LatLng>.from(state.liveTrackPoints)
        ..add(LatLng(event.position.latitude, event.position.longitude));
      emit(state.copyWith(liveTrackPoints: updatedPoints, currentPosition: event.position));
    }
  }

  /// 處理 [TrackingPaused] 事件：暫停記錄。
  void _onTrackingPaused(TrackingPaused event, Emitter<TrackingState> emit) {
    if (state.status == TrackingStatus.recording) {
      _timer?.cancel();
      _positionSubscription?.pause();
      emit(state.copyWith(status: TrackingStatus.paused));
    }
  }

  /// 處理 [TrackingResumed] 事件：繼續記錄。
  void _onTrackingResumed(TrackingResumed event, Emitter<TrackingState> emit) {
    if (state.status == TrackingStatus.paused) {
      _startTimer();
      _positionSubscription?.resume();
      emit(state.copyWith(status: TrackingStatus.recording));
    }
  }

  /// 處理 [TrackingStopped] 事件：停止記錄。
  void _onTrackingStopped(TrackingStopped event, Emitter<TrackingState> emit) {
    _positionSubscription?.cancel();
    _timer?.cancel();
    emit(state.copyWith(status: TrackingStatus.stopped));
  }

  /// 處理 [TrackSaved] 事件：將軌跡轉換為 GPX 格式並觸發地圖庫新增檔案。
  Future<void> _onTrackSaved(TrackSaved event, Emitter<TrackingState> emit) async {
    if (state.liveTrackPoints.isEmpty) {
      emit(state.copyWith(
        status: TrackingStatus.error,
        errorMessage: '沒有軌跡點可儲存',
      ));
      // 切換回 ready 狀態以允許用戶重新開始
      emit(state.copyWith(status: TrackingStatus.ready));
      return;
    }

    emit(state.copyWith(status: TrackingStatus.saving));

    try {
      final gpxString = _generateGpxContent(event.fileName, state.liveTrackPoints);
      
      _gpxLibraryBloc.add(FileAdded(
        fileName: event.fileName,
        gpxContent: gpxString,
      ));

      // 重設狀態，準備下一次記錄
      emit(const TrackingState(status: TrackingStatus.ready));

    } catch (e) {
      emit(state.copyWith(
        status: TrackingStatus.error,
        errorMessage: '儲存軌跡失敗: ${e.toString()}',
      ));
    }
  }

  /// 內部事件處理：計時器每秒觸發一次
  void _onTimerTicked(_TimerTicked event, Emitter<TrackingState> emit) {
    if (state.status == TrackingStatus.recording) {
      emit(state.copyWith(duration: state.duration + const Duration(seconds: 1)));
    }
  }

  /// 輔助函式：啟動計時器
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(const _TimerTicked());
    });
  }

  /// 輔助函式：根據軌跡點生成 GPX 1.1 格式的 XML 字串。
  String _generateGpxContent(String trackName, List<LatLng> points) {
    final gpx = Gpx();
    gpx.version = '1.1';
    gpx.creator = 'Mountain Hiking App';
    gpx.metadata = Metadata(
      time: DateTime.now().toUtc(),
      name: trackName,
    );

    final trackSegment = Trkseg();
    trackSegment.trkpts = points.map((p) {
      return Wpt(
        lat: p.latitude,
        lon: p.longitude,
        time: DateTime.now().toUtc(),
      );
    }).toList();

    gpx.trks.add(Trk(
      name: trackName,
      trksegs: [trackSegment],
    ));

    return GpxWriter().asString(gpx, pretty: true);
  }
}