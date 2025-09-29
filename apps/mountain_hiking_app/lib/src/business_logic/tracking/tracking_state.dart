part of 'tracking_bloc.dart';

/// 軌跡記錄功能的狀態枚舉
enum TrackingStatus {
  initial,         // 初始狀態，等待權限
  permissionDenied, // 權限被拒絕
  ready,           // 權限已獲取，準備就緒可以開始
  recording,       // 正在記錄
  paused,          // 已暫停
  stopped,         // 已停止，準備儲存
  saving,          // 正在儲存
  error,           // 發生錯誤
}

/// V1.0 - 軌跡記錄功能的狀態類別。
class TrackingState extends Equatable {
  /// 當前的狀態
  final TrackingStatus status;

  /// 即時記錄的軌跡點列表
  final List<LatLng> liveTrackPoints;

  /// 從檔案載入的參考軌跡線集合
  final Set<Polyline> referencePolylines;

  /// 記錄已進行的時間
  final Duration duration;

  /// 當前 GPS 位置
  final Position? currentPosition;

  /// 錯誤訊息
  final String? errorMessage;

  const TrackingState({
    this.status = TrackingStatus.initial,
    this.liveTrackPoints = const [],
    this.referencePolylines = const {},
    this.duration = Duration.zero,
    this.currentPosition,
    this.errorMessage,
  });

  /// 建立一個新的狀態副本
  TrackingState copyWith({
    TrackingStatus? status,
    List<LatLng>? liveTrackPoints,
    Set<Polyline>? referencePolylines,
    Duration? duration,
    Position? currentPosition,
    String? errorMessage,
  }) {
    return TrackingState(
      status: status ?? this.status,
      liveTrackPoints: liveTrackPoints ?? this.liveTrackPoints,
      referencePolylines: referencePolylines ?? this.referencePolylines,
      duration: duration ?? this.duration,
      currentPosition: currentPosition ?? this.currentPosition,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        liveTrackPoints,
        referencePolylines,
        duration,
        currentPosition,
        errorMessage,
      ];
}