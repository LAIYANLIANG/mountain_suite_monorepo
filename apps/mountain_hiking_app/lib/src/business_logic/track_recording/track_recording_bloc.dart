
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpx_core/gpx_core.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'track_recording_event.dart';
import 'track_recording_state.dart';
import 'package:flutter/material.dart';

class TrackRecordingBloc extends Bloc<TrackRecordingEvent, TrackRecordingState> {
  StreamSubscription<Position>? _positionStreamSubscription;
  List<LatLng> _trackPoints = [];

  TrackRecordingBloc() : super(const TrackRecordingState()) {
    on<RequestInitialLocation>(_onRequestInitialLocation);
    on<StartTracking>(_onStartTracking);
    on<PauseTracking>(_onPauseTracking);
    on<StopTracking>(_onStopTracking);
    on<SaveTrack>(_onSaveTrack);
    on<UpdateTracking>(_onUpdateTracking);
  }

  Future<bool> _handleLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    }
    return status.isGranted;
  }

  Future<void> _onRequestInitialLocation(
    RequestInitialLocation event,
    Emitter<TrackRecordingState> emit,
  ) async {
    final hasPermission = await _handleLocationPermission();
    if (hasPermission) {
      try {
        final Position position = await Geolocator.getCurrentPosition();
        emit(state.copyWith(currentLocation: LatLng(position.latitude, position.longitude)));
      } catch (e) {
        // Handle exceptions, e.g., location services disabled
        emit(state.copyWith(error: '無法獲取位置: ${e.toString()}'));
      }
    } else {
      emit(state.copyWith(error: '需要定位權限才能繼續'));
    }
  }

  Future<void> _onStartTracking(
    StartTracking event,
    Emitter<TrackRecordingState> emit,
  ) async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      emit(state.copyWith(error: '需要定位權限才能記錄軌跡'));
      return;
    }

    _trackPoints = []; // Reset points on new track
    emit(state.copyWith(isRecording: true, isPaused: false, polylines: {}));

    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // meters
      ),
    ).listen(
      (position) {
        add(UpdateTracking(position));
      },
      onError: (error) {
        emit(state.copyWith(error: '讀取位置時發生錯誤: $error'));
      },
    );
  }

  void _onPauseTracking(
    PauseTracking event,
    Emitter<TrackRecordingState> emit,
  ) {
    if (state.isRecording) {
      _positionStreamSubscription?.pause();
      emit(state.copyWith(isPaused: true));
    }
  }

  void _onStopTracking(
    StopTracking event,
    Emitter<TrackRecordingState> emit,
  ) {
    _positionStreamSubscription?.cancel();
    emit(state.copyWith(isRecording: false, isPaused: false));
  }

  Future<void> _onSaveTrack(
    SaveTrack event,
    Emitter<TrackRecordingState> emit,
  ) async {
    _positionStreamSubscription?.cancel();
    emit(state.copyWith(isRecording: false, isPaused: false));

    if (_trackPoints.isEmpty) {
      emit(state.copyWith(error: '沒有軌跡點可以儲存'));
      return;
    }

    try {
      final gpx = Gpx();
      gpx.creator = 'Mountain Hiking App';
      gpx.trks.add(Trk(
        trksegs: [
          Trkseg(
            trkpts: _trackPoints.map((point) {
              return Wpt(
                lat: point.latitude,
                lon: point.longitude,
                time: DateTime.now(),
              );
            }).toList(),
          ),
        ],
      ));

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${event.fileName}.gpx');
      final gpxString = GpxWriter().asString(gpx, pretty: true);
      await file.writeAsString(gpxString);

      _trackPoints = [];
      emit(const TrackRecordingState()); // Reset state
      emit(state.copyWith(successMessage: '軌跡已儲存至 ${file.path}'));
    } catch (e) {
      emit(state.copyWith(error: '儲存失敗: ${e.toString()}'));
    }
  }

  void _onUpdateTracking(
    UpdateTracking event,
    Emitter<TrackRecordingState> emit,
  ) {
    final newPoint = LatLng(event.position.latitude, event.position.longitude);
    _trackPoints.add(newPoint);

    final updatedPolyline = Polyline(
      polylineId: const PolylineId('current_track'),
      color:  Colors.blue,
      points: List.from(_trackPoints),
      width: 5,
    );

    emit(state.copyWith(polylines: {updatedPolyline}));
  }

  @override
  Future<void> close() {
    _positionStreamSubscription?.cancel();
    return super.close();
  }
}
