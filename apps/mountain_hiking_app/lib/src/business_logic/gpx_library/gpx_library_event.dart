part of 'gpx_library_bloc.dart';

/// V1.0 - GPX 地圖庫功能的事件基底類別。
@immutable
abstract class GpxLibraryEvent extends Equatable {
  const GpxLibraryEvent();

  @override
  List<Object> get props => [];
}

/// 請求載入所有本地 GPX 檔案。
/// BLoC 初始化時會自動觸發此事件。
class LoadFilesRequested extends GpxLibraryEvent {}

/// 使用者透過 file_picker 選擇了一個或多個檔案後觸發。
class FileUploaded extends GpxLibraryEvent {
  final List<PlatformFile> platformFiles;

  const FileUploaded({required this.platformFiles});

  @override
  List<Object> get props => [platformFiles];
}

/// 從其他頁面 (如規劃、記錄) 傳入一個新的 GPX 檔案時觸發。
class FileAdded extends GpxLibraryEvent {
  final String fileName;
  final String gpxContent;

  const FileAdded({required this.fileName, required this.gpxContent});

  @override
  List<Object> get props => [fileName, gpxContent];
}

/// 請求刪除一個指定的檔案。
class FileDeleted extends GpxLibraryEvent {
  final String filePath;

  const FileDeleted({required this.filePath});

  @override
  List<Object> get props => [filePath];
}

/// 請求將一個檔案儲存到裝置的公共下載資料夾。
class FileDownloaded extends GpxLibraryEvent {
  final String filePath;

  const FileDownloaded({required this.filePath});

  @override
  List<Object> get props => [filePath];
}