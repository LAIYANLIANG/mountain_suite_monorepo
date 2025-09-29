part of 'tracking_bloc.dart';

@immutable
abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

/// 請求定位權限
class PermissionRequested extends TrackingEvent {}

/// 載入 GPX 檔案作為參考路線
class GpxFileLoaded extends TrackingEvent {
  final String filePath;
  const GpxFileLoaded({required this.filePath});
  @override
  List<Object> get props => [filePath];
}

/// 開始記錄
class TrackingStarted extends TrackingEvent {}

/// 暫停記錄
class TrackingPaused extends TrackingEvent {}

/// 繼續記錄
class TrackingResumed extends TrackingEvent {}

/// 停止記錄
class TrackingStopped extends TrackingEvent {}

/// 儲存軌跡
class TrackSaved extends TrackingEvent {
  final String fileName;
  const TrackSaved({required this.fileName});
  @override
  List<Object> get props => [fileName];
}

/// 內部事件：GPS 位置更新
class _PositionUpdated extends TrackingEvent {
  final Position position;
  const _PositionUpdated(this.position);
  @override
  List<Object> get props => [position];
}

/// 內部事件：計時器更新
class _TimerTicked extends TrackingEvent {
  const _TimerTicked();
}