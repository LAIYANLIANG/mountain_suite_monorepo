import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_library/gpx_library_bloc.dart';
import 'package:mountain_hiking_app/src/data/models/gpx_planning_model.dart';
import 'package:xml/xml.dart';

part 'gpx_planning_event.dart';
part 'gpx_planning_state.dart';

/// V1.0 - GPX 規劃功能的業務邏輯核心 (BLoC)。
class GpxPlanningBloc extends Bloc<GpxPlanningEvent, GpxPlanningState> {
  final GpxLibraryBloc _gpxLibraryBloc;

  GpxPlanningBloc({required GpxLibraryBloc gpxLibraryBloc})
      : _gpxLibraryBloc = gpxLibraryBloc,
        super(const GpxPlanningState()) {
    on<LoadGpxRequested>(_onLoadGpxRequested);
    on<WaypointAdded>(_onWaypointAdded);
    on<WaypointUpdated>(_onWaypointUpdated);
    on<WaypointDeleted>(_onWaypointDeleted);
    on<WaypointsReordered>(_onWaypointsReordered);
    on<TrackSegmentDeleted>(_onTrackSegmentDeleted);
    on<UndoRequested>(_onUndoRequested);
    on<RedoRequested>(_onRedoRequested);
    on<SaveGpxRequested>(_onSaveGpxRequested);
  }

  /// 處理 [LoadGpxRequested] 事件：解析 XML 並初始化狀態。
  void _onLoadGpxRequested(LoadGpxRequested event, Emitter<GpxPlanningState> emit) {
    emit(state.copyWith(status: GpxPlanningStatus.loading));
    try {
      final gpxData = _parseGpx(event.gpxRawXml);
      _pushToHistory(emit, gpxData);
    } catch (e) {
      emit(state.copyWith(status: GpxPlanningStatus.error, errorMessage: e.toString()));
    }
  }

  /// 處理 [WaypointAdded] 事件。
  void _onWaypointAdded(WaypointAdded event, Emitter<GpxPlanningState> emit) {
    if (state.gpxData == null) return;
    final newData = state.gpxData!.clone();
    newData.wpts.add(Wpt(
      lat: event.position.latitude,
      lon: event.position.longitude,
      name: '航點 ${newData.wpts.length + 1}',
    ));
    _pushToHistory(emit, newData);
  }

  /// 處理 [WaypointUpdated] 事件。
  void _onWaypointUpdated(WaypointUpdated event, Emitter<GpxPlanningState> emit) {
    if (state.gpxData == null || event.index >= state.gpxData!.wpts.length) return;
    final newData = state.gpxData!.clone();
    newData.wpts[event.index] = event.updatedWpt;
    _pushToHistory(emit, newData);
  }

  /// 處理 [WaypointDeleted] 事件。
  void _onWaypointDeleted(WaypointDeleted event, Emitter<GpxPlanningState> emit) {
    if (state.gpxData == null || event.index >= state.gpxData!.wpts.length) return;
    final newData = state.gpxData!.clone();
    newData.wpts.removeAt(event.index);
    _pushToHistory(emit, newData);
  }

  /// 處理 [WaypointsReordered] 事件。
  void _onWaypointsReordered(WaypointsReordered event, Emitter<GpxPlanningState> emit) {
    if (state.gpxData == null) return;
    final newData = state.gpxData!.clone();
    final item = newData.wpts.removeAt(event.oldIndex);
    newData.wpts.insert(event.newIndex, item);
    _pushToHistory(emit, newData);
  }

  /// 處理 [TrackSegmentDeleted] 事件。
  void _onTrackSegmentDeleted(TrackSegmentDeleted event, Emitter<GpxPlanningState> emit) {
    if (state.gpxData == null) return;
    final newData = state.gpxData!.clone();
    // 安全性檢查
    if (event.trkIndex < newData.trks.length && event.segIndex < newData.trks[event.trkIndex].trksegs.length) {
      final segment = newData.trks[event.trkIndex].trksegs[event.segIndex];
      if (event.startIndex < segment.trkpts.length && event.endIndex < segment.trkpts.length) {
        segment.trkpts.removeRange(event.startIndex, event.endIndex + 1);
      }
    }
    _pushToHistory(emit, newData);
  }

  /// 處理 [UndoRequested] 事件。
  void _onUndoRequested(UndoRequested event, Emitter<GpxPlanningState> emit) {
    if (state.canUndo) {
      final newIndex = state.historyIndex - 1;
      emit(state.copyWith(
        gpxData: state.history[newIndex].clone(),
        historyIndex: newIndex,
      ));
    }
  }

  /// 處理 [RedoRequested] 事件。
  void _onRedoRequested(RedoRequested event, Emitter<GpxPlanningState> emit) {
    if (state.canRedo) {
      final newIndex = state.historyIndex + 1;
      emit(state.copyWith(
        gpxData: state.history[newIndex].clone(),
        historyIndex: newIndex,
      ));
    }
  }

  /// 處理 [SaveGpxRequested] 事件。
  // Gemini: 根據使用者反饋，在儲存前先更新 GPX 內部的名稱。
  void _onSaveGpxRequested(SaveGpxRequested event, Emitter<GpxPlanningState> emit) {
    if (state.gpxData == null) return;

    // 建立一個可修改的 gpxData 副本
    final updatedGpxData = state.gpxData!.clone();

    // 更新 metadata 中的名稱
    final newName = event.trackName;
    if (updatedGpxData.metadata != null) {
      updatedGpxData.metadata!.name = newName;
    } else {
      updatedGpxData.metadata = Metadata(name: newName);
    }

    try {
      // 使用更新後的資料來建立 GPX 字串
      final gpxString = _buildGpxString(updatedGpxData);

      // 確保檔案名稱以 .gpx 結尾
      final finalFileName =
          event.fileName.toLowerCase().endsWith('.gpx') ? event.fileName : '${event.fileName}.gpx';

      // 呼叫 GpxLibraryBloc 來儲存檔案
      _gpxLibraryBloc.add(FileAdded(fileName: finalFileName, gpxContent: gpxString));

      // 可以在此發送一個成功狀態，讓 UI 顯示通知
      // emit(state.copyWith(status: GpxPlanningStatus.saved));
    } catch (e) {
      emit(state.copyWith(status: GpxPlanningStatus.error, errorMessage: e.toString()));
    }
  }

  /// 將新的 GpxData 狀態推入歷史堆疊。
  void _pushToHistory(Emitter<GpxPlanningState> emit, GpxData data) {
    // 如果在歷史紀錄中往回走過，則先前的「未來」路徑將被捨棄
    final newHistory = state.history.sublist(0, state.historyIndex + 1);
    newHistory.add(data);

    emit(state.copyWith(
      status: GpxPlanningStatus.loaded,
      gpxData: data.clone(), // 確保狀態中的 gpxData 也是一個拷貝
      history: newHistory,
      historyIndex: newHistory.length - 1,
      clearError: true,
    ));
  }

  /// 從 XML 字串解析出 GpxData 物件。
  GpxData _parseGpx(String gpxRawXml) {
    final document = XmlDocument.parse(gpxRawXml);
    final gpxElement = document.rootElement;

    final gpxData = GpxData(
      creator: gpxElement.getAttribute('creator') ?? '',
      metadata: gpxElement.findElements('metadata').map((node) {
        return Metadata(
          name: node.findElements('name').firstOrNull?.innerText,
          desc: node.findElements('desc').firstOrNull?.innerText,
          time: DateTime.tryParse(node.findElements('time').firstOrNull?.innerText ?? ''),
        );
      }).firstOrNull,
      wpts: gpxElement.findElements('wpt').map((node) {
        return Wpt(
          lat: double.parse(node.getAttribute('lat')!),
          lon: double.parse(node.getAttribute('lon')!),
          ele: double.tryParse(node.findElements('ele').firstOrNull?.innerText ?? ''),
          time: DateTime.tryParse(node.findElements('time').firstOrNull?.innerText ?? ''),
          name: node.findElements('name').firstOrNull?.innerText,
          desc: node.findElements('desc').firstOrNull?.innerText,
        );
      }).toList(),
      trks: gpxElement.findElements('trk').map((node) {
        return Trk(
          name: node.findElements('name').firstOrNull?.innerText,
          trksegs: node.findElements('trkseg').map((segNode) {
            return Trkseg(
              trkpts: segNode.findElements('trkpt').map((ptNode) {
                return Trkpt(
                  lat: double.parse(ptNode.getAttribute('lat')!),
                  lon: double.parse(ptNode.getAttribute('lon')!),
                  ele: double.tryParse(ptNode.findElements('ele').firstOrNull?.innerText ?? ''),
                  time: DateTime.tryParse(ptNode.findElements('time').firstOrNull?.innerText ?? ''),
                );
              }).toList(),
            );
          }).toList(),
        );
      }).toList(),
    );
    return gpxData;
  }

  /// 將 GpxData 物件轉換回 GPX 1.1 格式的 XML 字串。
  String _buildGpxString(GpxData gpxData) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('gpx', attributes: {
      'version': '1.1',
      'creator': gpxData.creator ?? 'Mountain Hiking App',
      'xmlns': 'http://www.topografix.com/GPX/1/1',
      'xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance',
      'xsi:schemaLocation': 'http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd',
    }, nest: () {
      if (gpxData.metadata != null) {
        builder.element('metadata', nest: () {
          if (gpxData.metadata!.name != null) {
            builder.element('name', nest: gpxData.metadata!.name);
          }
          if (gpxData.metadata!.desc != null) {
            builder.element('desc', nest: gpxData.metadata!.desc);
          }
          if (gpxData.metadata!.time != null) {
            builder.element('time', nest: gpxData.metadata!.time!.toUtc().toIso8601String());
          }
        });
      }

      for (final wpt in gpxData.wpts) {
        builder.element('wpt', attributes: {'lat': wpt.lat.toString(), 'lon': wpt.lon.toString()}, nest: () {
          if (wpt.ele != null) builder.element('ele', nest: wpt.ele.toString());
          if (wpt.time != null) builder.element('time', nest: wpt.time!.toUtc().toIso8601String());
          if (wpt.name != null) builder.element('name', nest: wpt.name);
          if (wpt.desc != null) builder.element('desc', nest: wpt.desc);
        });
      }

      for (final trk in gpxData.trks) {
        builder.element('trk', nest: () {
          if (trk.name != null) {
            builder.element('name', nest: trk.name);
          }
          for (final seg in trk.trksegs) {
            builder.element('trkseg', nest: () {
              for (final pt in seg.trkpts) {
                builder.element('trkpt', attributes: {'lat': pt.lat.toString(), 'lon': pt.lon.toString()}, nest: () {
                  if (pt.ele != null) builder.element('ele', nest: pt.ele.toString());
                  if (pt.time != null) builder.element('time', nest: pt.time!.toUtc().toIso8601String());
                });
              }
            });
          }
        });
      }
    });
    return builder.buildDocument().toXmlString(pretty: true);
  }
}