
import 'package:equatable/equatable.dart';

/// V1.0 - GPX 地圖庫項目資料模型
///
/// 代表儲存在本地端的一個 GPX 檔案。
class GpxLibraryItem extends Equatable {
  /// 檔案在應用程式私有目錄中的完整路徑。
  /// 用於讀取、刪除或分享檔案。
  final String filePath;

  /// 從檔案路徑中提取的原始檔名，例如 "my_track.gpx"。
  final String fileName;

  /// 檔案的最後修改日期。
  /// 用於排序和顯示。
  final DateTime modifiedDate;

  /// 從 GPX 檔案的 <metadata><name> 標籤中解析出的名稱。
  /// 如果解析失敗或標籤不存在，則會使用 [fileName] 作為備用。
  final String displayName;

  const GpxLibraryItem({
    required this.filePath,
    required this.fileName,
    required this.modifiedDate,
    required this.displayName,
  });

  @override
  List<Object> get props => [filePath, fileName, modifiedDate, displayName];
}
