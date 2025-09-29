part of 'gpx_planning_bloc.dart';

/// V1.0 - GPX 規劃功能的事件基底類別。
@immutable
abstract class GpxPlanningEvent extends Equatable {
  const GpxPlanningEvent();

  @override
  List<Object?> get props => [];
}

/// 請求載入一個 GPX 檔案的原始 XML 字串。
class LoadGpxRequested extends GpxPlanningEvent {
  final String gpxRawXml;
  const LoadGpxRequested({required this.gpxRawXml});

  @override
  List<Object> get props => [gpxRawXml];
}

/// 在地圖上點擊以新增一個航點。
class WaypointAdded extends GpxPlanningEvent {
  final LatLng position;
  const WaypointAdded({required this.position});

  @override
  List<Object> get props => [position];
}

/// 更新一個現有航點的資訊。
class WaypointUpdated extends GpxPlanningEvent {
  final int index;
  final Wpt updatedWpt;
  const WaypointUpdated({required this.index, required this.updatedWpt});

  @override
  List<Object> get props => [index, updatedWpt];
}

/// 刪除一個指定的航點。
class WaypointDeleted extends GpxPlanningEvent {
  final int index;
  const WaypointDeleted({required this.index});

  @override
  List<Object> get props => [index];
}

/// 航點列表被使用者拖曳排序後觸發。
class WaypointsReordered extends GpxPlanningEvent {
  final int oldIndex;
  final int newIndex;
  const WaypointsReordered({required this.oldIndex, required this.newIndex});

  @override
  List<Object> get props => [oldIndex, newIndex];
}

/// 刪除軌跡中的一個區段。
class TrackSegmentDeleted extends GpxPlanningEvent {
  final int trkIndex;
  final int segIndex;
  final int startIndex;
  final int endIndex;

  const TrackSegmentDeleted({
    required this.trkIndex,
    required this.segIndex,
    required this.startIndex,
    required this.endIndex,
  });

  @override
  List<Object> get props => [trkIndex, segIndex, startIndex, endIndex];
}

/// 請求復原上一步操作。
class UndoRequested extends GpxPlanningEvent {}

/// 請求重做下一步操作。
class RedoRequested extends GpxPlanningEvent {}

/// 請求儲存當前的 GPX 編輯結果。
class SaveGpxRequested extends GpxPlanningEvent {
  /// 檔案系統中儲存的檔案名稱 (e.g., "MyTrack.gpx")。
  final String fileName;
  /// GPX 內部 <metadata><name> 標籤的值。
  final String trackName;

  const SaveGpxRequested({required this.fileName, required this.trackName});

  @override
  List<Object> get props => [fileName, trackName];
}