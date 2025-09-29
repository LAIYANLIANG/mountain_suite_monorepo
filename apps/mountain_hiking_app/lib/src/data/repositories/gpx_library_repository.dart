import 'dart:io';
import 'dart:typed_data';
import 'package:mountain_hiking_app/src/data/models/gpx_track.dart';
import 'package:mountain_hiking_app/src/data/providers/gpx_data_provider.dart';

/// [MVP Refactor] GPX 資料倉儲層 (Repository)
///
/// 這個類別現在扮演一個代理 (Proxy) 或外觀 (Facade) 的角色。
/// 它本身不包含任何業務邏輯，而是持有一個 GpxDataProvider 的實例，
/// 並將所有來自 BLoC 層的請求轉發給該 Provider。
///
/// 這種設計的好處是，上層的 BLoC 完全不需要知道數據究竟是來自本地還是雲端，
/// 使得數據層的抽換變得非常容易。
class GpxLibraryRepository {
  final GpxDataProvider _provider;

  GpxLibraryRepository({required GpxDataProvider provider}) : _provider = provider;

  Future<List<GpxTrack>> getTracks() => _provider.getTracks();

  Future<GpxTrack> addTrack(Uint8List gpxBytes, String customName, String originalFileName) =>
      _provider.addTrack(gpxBytes, customName, originalFileName);

  Future<void> deleteTrack(String trackId) => _provider.deleteTrack(trackId);

  Future<String> getTrackLocalPath(String trackId) =>
      _provider.getTrackLocalPath(trackId);

  // FIX: Added missing method that was being called by TrackingBloc.
  Future<void> saveGpxFile(String trackName, String gpxContent) async {
    final bytes = Uint8List.fromList(gpxContent.codeUnits);
    // Use the trackName for both customName and originalFileName for simplicity.
    await addTrack(bytes, trackName, '$trackName.gpx');
  }

  // FIX: Added missing method that was being called by TrackingBloc.
  Future<String> readGpxFileContent(String trackId) async {
    final localPath = await getTrackLocalPath(trackId);
    final file = File(localPath);
    return await file.readAsString();
  }
}