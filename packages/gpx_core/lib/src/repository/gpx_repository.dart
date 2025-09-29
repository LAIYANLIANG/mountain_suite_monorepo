import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';

// 【重要】這是一個佔位符！你需要將你原本的 GpxMerger 邏輯放在這裡。
// 由於我沒有 gpx_merger.dart 的檔案，我先建立一個模擬的類別。
// 請用你自己的 GpxMerger 類別和方法取代它。
class GpxMerger {
  static Uint8List mergeGpxFiles(List<Uint8List> files) {
    // 這裡應該是你實際的合併邏輯
    final String mergedContent = files
        .map((bytes) => String.fromCharCodes(bytes))
        .join('\n\n');
    return Uint8List.fromList(mergedContent.codeUnits);
  }
}


class GpxRepository {
  static const int _maxFileSize = 500 * 1024; // 500KB

  /// 挑選並驗證單一 GPX 檔案
  /// 成功則返回 PlatformFile，失敗或使用者取消則返回 null
  Future<PlatformFile?> pickAndValidateFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );

      if (result == null || result.files.single.bytes == null) {
        return null; // 使用者取消選擇
      }

      final file = result.files.single;

      if (!file.name.toLowerCase().endsWith('.gpx')) {
        throw Exception('請選擇 GPX 檔案');
      }

      if (file.size > _maxFileSize) {
        throw Exception('檔案大小超過 500KB 限制');
      }

      return file;
    } catch (e) {
      // 重新拋出錯誤，讓 BLoC 層可以捕捉到
      rethrow;
    }
  }

  /// 合併多個 GPX 檔案並儲存，成功後返回儲存路徑
  Future<String> mergeAndSaveGpxFiles(List<PlatformFile> files) async {
    if (files.isEmpty) {
      throw Exception('沒有選擇任何檔案');
    }

    final List<Uint8List> fileContents = files.map((f) => f.bytes!).toList();
    final Uint8List mergedContent = GpxMerger.mergeGpxFiles(fileContents);
    final String fileName = 'merged_${DateTime.now().millisecondsSinceEpoch}.gpx';

    // 優先嘗試儲存到 Download 資料夾 (僅限 Android)
    if (Platform.isAndroid) {
      try {
        final directory = Directory('/storage/emulated/0/Download');
        if (await directory.exists()) {
          final filePath = '${directory.path}/$fileName';
          await File(filePath).writeAsBytes(mergedContent);
          return filePath;
        }
      } catch (e) {
        // 如果寫入 Download 資料夾失敗，則降級使用 FileSaver
      }
    }
    
    // 使用 FileSaver 作為備用方案 (適用於 iOS 和部分 Android)
    final savedPath = await FileSaver.instance.saveFile(
      name: fileName.replaceAll('.gpx', ''),
      bytes: mergedContent,
      mimeType: MimeType.other,
    );
    
    return savedPath;
  }
}