part of 'gpx_planning_bloc.dart';

/// GPX 規劃功能的狀態枚舉
enum GpxPlanningStatus { initial, loading, loaded, error }

/// V1.0 - GPX 規劃功能的狀態類別。
class GpxPlanningState extends Equatable {
  final GpxPlanningStatus status;

  /// 當前正在編輯的 GPX 資料的唯讀版本。
  /// UI 層應該總是從這裡讀取資料來繪製地圖和列表。
  final GpxData? gpxData;

  /// 用於實現 Undo/Redo 的狀態歷史堆疊。
  /// 儲存了每一次操作後的 GpxData 物件。
  final List<GpxData> history;

  /// 指向 history 堆疊中的當前狀態索引。
  final int historyIndex;

  final String? errorMessage;

  const GpxPlanningState({
    this.status = GpxPlanningStatus.initial,
    this.gpxData,
    this.history = const [],
    this.historyIndex = -1,
    this.errorMessage,
  });

  /// 是否可以執行復原操作。
  bool get canUndo => historyIndex > 0;

  /// 是否可以執行重做操作。
  bool get canRedo => historyIndex < history.length - 1;

  GpxPlanningState copyWith({
    GpxPlanningStatus? status,
    GpxData? gpxData,
    List<GpxData>? history,
    int? historyIndex,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GpxPlanningState(
      status: status ?? this.status,
      gpxData: gpxData ?? this.gpxData,
      history: history ?? this.history,
      historyIndex: historyIndex ?? this.historyIndex,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, gpxData, history, historyIndex, errorMessage];
}