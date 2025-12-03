
part of 'gpx_library_bloc.dart';

/// GPX 地圖庫的狀態枚舉
enum GpxLibraryStatus { initial, loading, loaded, empty, error, success, idle }

/// V1.0 - GPX 地圖庫功能的狀態類別。
class GpxLibraryState extends Equatable {
  /// 當前的狀態，用於 UI 判斷要顯示何種元件。
  final GpxLibraryStatus status;

  /// 當 status 為 'loaded' 時，儲存已排序的 GPX 檔案項目列表。
  final List<GpxLibraryItem> files;

  /// 當 status 為 'error' 時，儲存錯誤訊息。
  final String? errorMessage;

  /// 當 status 為 'success' 時，可選的成功訊息。
  final String? successMessage;

  const GpxLibraryState({
    this.status = GpxLibraryStatus.initial,
    this.files = const [],
    this.errorMessage,
    this.successMessage,
  });

  GpxLibraryState copyWith({
    GpxLibraryStatus? status,
    List<GpxLibraryItem>? files,
    String? errorMessage,
    String? successMessage,
  }) {
    return GpxLibraryState(
      status: status ?? this.status,
      files: files ?? this.files,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, files, errorMessage, successMessage];
}
