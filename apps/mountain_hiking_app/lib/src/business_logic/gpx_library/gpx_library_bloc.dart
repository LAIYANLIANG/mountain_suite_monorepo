import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:meta/meta.dart';
import 'package:mountain_hiking_app/src/data/models/gpx_library_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart' as p;

part 'gpx_library_event.dart';
part 'gpx_library_state.dart';


/// V1.0 - GPX 地圖庫功能的業務邏輯核心 (BLoC)。
///
/// 負責處理所有與本地 GPX 檔案儲存相關的操作。
class GpxLibraryBloc extends Bloc<GpxLibraryEvent, GpxLibraryState> {
  GpxLibraryBloc() : super(const GpxLibraryState()) {
    // 註冊事件處理器
    on<LoadFilesRequested>(_onLoadFilesRequested);
    on<FileUploaded>(_onFileUploaded);
    on<FileAdded>(_onFileAdded);
    on<FileDeleted>(_onFileDeleted);
    on<FileDownloaded>(_onFileDownloaded);

    // BLoC 初始化時立即觸發載入事件
    add(LoadFilesRequested());
  }

  /// 處理 [LoadFilesRequested] 事件：掃描、解析並載入本地 GPX 檔案。
  Future<void> _onLoadFilesRequested(
    LoadFilesRequested event,
    Emitter<GpxLibraryState> emit,
  ) async {
    emit(state.copyWith(status: GpxLibraryStatus.loading));
    try {
      final directory = await getApplicationDocumentsDirectory();
      final dir = Directory(directory.path);
      final files = dir.listSync().where((file) => file.path.endsWith('.gpx')).toList();

      if (files.isEmpty) {
        emit(state.copyWith(status: GpxLibraryStatus.empty));
        return;
      }

      final List<GpxLibraryItem> items = [];
      for (final file in files) {
        final fileStat = await file.stat();
        final fileContent = utf8.decode(await (file as File).readAsBytes(), allowMalformed: true);
        final displayName = _parseGpxName(fileContent) ?? file.path.split('/').last;

        items.add(GpxLibraryItem(
          filePath: file.path,
          fileName: file.path.split('/').last,
          modifiedDate: fileStat.modified,
          displayName: displayName,
        ));
      }

      // 按修改日期降序排序
      items.sort((a, b) => b.modifiedDate.compareTo(a.modifiedDate));

      emit(state.copyWith(status: GpxLibraryStatus.loaded, files: items));
    } catch (e) {
      emit(state.copyWith(status: GpxLibraryStatus.error, errorMessage: e.toString()));
    }
  }

  /// 處理 [FileUploaded] 事件：將使用者選擇的檔案複製到應用程式目錄。
  Future<void> _onFileUploaded(
    FileUploaded event,
    Emitter<GpxLibraryState> emit,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      for (final file in event.platformFiles) {
        if (file.path != null) { // 確保有實體檔案路徑
          // Gemini: 確保儲存的檔案名稱以 .gpx 結尾
          final originalName = file.name;
          final newName = originalName.endsWith('.gpx')
              ? originalName
              : '$originalName.gpx';
          final newPath = '${directory.path}/$newName';
          await File(file.path!).copy(newPath);
        }
      }
      // 操作完成後，觸發重新載入以刷新列表
      add(LoadFilesRequested());
    } catch (e) {
      emit(state.copyWith(status: GpxLibraryStatus.error, errorMessage: '檔案上傳失敗: ${e.toString()}'));
    }
  }

  /// 處理 [FileAdded] 事件：從其他頁面接收 GPX 內容並儲存。
  Future<void> _onFileAdded(
    FileAdded event,
    Emitter<GpxLibraryState> emit,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = event.fileName.endsWith('.gpx') ? event.fileName : '${event.fileName}.gpx';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(event.gpxContent);
      add(LoadFilesRequested());
    } catch (e) {
      emit(state.copyWith(status: GpxLibraryStatus.error, errorMessage: '檔案新增失敗: ${e.toString()}'));
    }
  }

  /// 處理 [FileDeleted] 事件：刪除指定的 GPX 檔案。
  Future<void> _onFileDeleted(
    FileDeleted event,
    Emitter<GpxLibraryState> emit,
  ) async {
    try {
      final file = File(event.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      add(LoadFilesRequested());
    } catch (e) {
      emit(state.copyWith(status: GpxLibraryStatus.error, errorMessage: '檔案刪除失敗: ${e.toString()}'));
    }
  }

  /// 處理 [FileDownloaded] 事件：將內部檔案儲存到公共下載資料夾。
  Future<void> _onFileDownloaded(
    FileDownloaded event,
    Emitter<GpxLibraryState> emit,
  ) async {
    try {
      // 1. 從私有路徑讀取檔案
      final file = File(event.filePath);
      final bytes = await file.readAsBytes();

      // 2. 獲取原始檔案名稱
      final String fileName = p.basename(event.filePath); 

      // 3. 呼叫 FileSaver 將 bytes 儲存
      final String savedPath = await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        mimeType: MimeType.custom,
        customMimeType: 'application/gpx+xml',
      );

      // 儲存成功
      emit(state.copyWith(
        status: GpxLibraryStatus.success, 
        successMessage: '檔案已儲存至 $savedPath',
      ));
    
    } catch (e) {
      // 4. 處理任何可能的錯誤
      emit(state.copyWith(
        status: GpxLibraryStatus.error, 
        errorMessage: '儲存檔案時發生錯誤：${e.toString()}',
      ));
    }
  }

  /// 從 GPX XML 字串中解析 <metadata><name>。
  String? _parseGpxName(String gpxContent) {
    try {
      final document = XmlDocument.parse(gpxContent);
      return document.findAllElements('name').firstOrNull?.innerText;
    } catch (e) {
      // 解析失敗則返回 null
      return null;
    }
  }
}