import 'dart:typed_data';
import 'package:mountain_hiking_app/src/data/models/gpx_track.dart';

/// [MVP Refactor] GPX 數據提供者抽象介面
///
/// 定義了 GPX 數據來源所需實現的標準化方法。
/// 這種設計允許我們將數據來源（本地資料庫或 Firebase）與業務邏輯層 (Bloc) 分離，
/// 使得在不同模式下切換數據來源變得容易，而無需修改上層的業務邏輯。
abstract class GpxDataProvider {
  /// 取得所有軌跡的元數據。
  Future<List<GpxTrack>> getTracks();

  /// 從位元組數據新增一個軌跡，並返回其元數據。
  Future<GpxTrack> addTrack(Uint8List gpxBytes, String customName, String originalFileName);

  /// 根據軌跡 ID 刪除一個軌跡。
  Future<void> deleteTrack(String trackId);

  /// 根據軌跡 ID 取得其本地檔案路徑。
  /// 對於遠端提供者，這可能需要先將檔案下載到本地。
  Future<String> getTrackLocalPath(String trackId);
}
