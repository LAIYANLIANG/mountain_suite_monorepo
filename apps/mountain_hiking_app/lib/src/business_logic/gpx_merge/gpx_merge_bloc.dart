import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_merger_service.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'package:xml/xml.dart';

// Events
@immutable
abstract class GpxMergeEvent {}

class LoadInitialFiles extends GpxMergeEvent {
  final List<String> filePaths;
  LoadInitialFiles(this.filePaths);
}

class AddFilesClicked extends GpxMergeEvent {}

class DeleteFile extends GpxMergeEvent {
  final PlatformFile file;
  DeleteFile(this.file);
}

class MergeFilesClicked extends GpxMergeEvent {
  // Gemini: 加入軌跡名稱參數，以便在合併時寫入 GPX 內部。
  final String trackName;
  MergeFilesClicked({required this.trackName});
}

// States
@immutable
abstract class GpxMergeState {}

class GpxMergeInitial extends GpxMergeState {}

class GpxMergeLoading extends GpxMergeState {}

class GpxMergeLoaded extends GpxMergeState {
  final List<PlatformFile> files;
  GpxMergeLoaded(this.files);
}

class GpxMergeSuccess extends GpxMergeState {
  final Uint8List mergedGpxBytes;
  GpxMergeSuccess({required this.mergedGpxBytes});
}

class GpxMergeError extends GpxMergeState {
  final String message;
  final String? errorCode;
  final Map<String, dynamic>? details;

  GpxMergeError(this.message, {this.errorCode, this.details});
}


class GpxMergeBloc extends Bloc<GpxMergeEvent, GpxMergeState> {
  GpxMergeBloc() : super(GpxMergeInitial()) {
    on<LoadInitialFiles>(_onLoadInitialFiles);
    on<AddFilesClicked>(_onAddFilesClicked);
    on<DeleteFile>(_onDeleteFile);
    on<MergeFilesClicked>(_onMergeFilesClicked);
  }

  Future<void> _onLoadInitialFiles(LoadInitialFiles event, Emitter<GpxMergeState> emit) async {
    emit(GpxMergeLoading());
    try {
      final List<PlatformFile> loadedFiles = [];
      for (String path in event.filePaths) {
        final file = File(path);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          final name = p.basename(path);
          final size = bytes.length;

          if (size > 1000 * 1024) { // 1000KB limit
            emit(GpxMergeError(
              '檔案 "$name" 過大，超過 1000KB 的限制。',
              errorCode: 'file_too_large',
              details: {'fileName': name},
            ));
          } else {
            loadedFiles.add(PlatformFile(name: name, size: size, bytes: bytes, path: path));
          }
        }
      }
      emit(GpxMergeLoaded(loadedFiles));
    } catch (e) {
      emit(GpxMergeError(
        '載入預選檔案時發生錯誤: $e',
        errorCode: 'load_initial_files_failed',
      ));
    }
  }

  Future<void> _onAddFilesClicked(AddFilesClicked event, Emitter<GpxMergeState> emit) async {
    final currentState = state;
    List<PlatformFile> currentFiles = currentState is GpxMergeLoaded ? List.from(currentState.files) : [];

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
        withData: true,
      );

      if (result != null) {
        if ((currentFiles.length + result.files.length) > 3) {
          emit(GpxMergeError(
            '最多只能選擇 3 個檔案。',
            errorCode: 'too_many_files',
          ));
          emit(GpxMergeLoaded(currentFiles));
          return;
        }

        for (var file in result.files) {
          if (!file.name.toLowerCase().endsWith('.gpx')) {
            emit(GpxMergeError(
              '檔案 "${file.name}" 不是 GPX 檔案。',
              errorCode: 'not_gpx_file',
              details: {'fileName': file.name},
            ));
            continue;
          }
          if (file.size > 1000 * 1024) { // 1000KB limit
            emit(GpxMergeError(
              '檔案 "${file.name}" 過大，超過 1000KB 的限制。',
              errorCode: 'file_too_large',
              details: {'fileName': file.name},
            ));
          } else if (currentFiles.length < 3) {
            currentFiles.add(file);
          }
        }
        emit(GpxMergeLoaded(currentFiles));
      }
    } catch (e) {
      emit(GpxMergeError(
        '選擇檔案時發生錯誤: $e',
        errorCode: 'pick_file_failed',
      ));
    }
  }

  void _onDeleteFile(DeleteFile event, Emitter<GpxMergeState> emit) {
    if (state is GpxMergeLoaded) {
      final currentFiles = List<PlatformFile>.from((state as GpxMergeLoaded).files);
      currentFiles.removeWhere((file) => file.path == event.file.path && file.name == event.file.name);
      emit(GpxMergeLoaded(currentFiles));
    }
  }

  Future<void> _onMergeFilesClicked(MergeFilesClicked event, Emitter<GpxMergeState> emit) async {
    if (state is GpxMergeLoaded) {
      final currentFiles = (state as GpxMergeLoaded).files;
      if (currentFiles.length < 2) {
        emit(GpxMergeError(
          '請至少選擇 2 個檔案進行合併。',
          errorCode: 'too_few_files',
        ));
        emit(GpxMergeLoaded(currentFiles));
        return;
      }

      emit(GpxMergeLoading());

      try {
        // 1. 執行合併
        final List<Uint8List> gpxDataList = currentFiles.map((file) => file.bytes!).toList();
        final mergedGpxBytes = GpxMergerService.mergeGpxFiles(gpxDataList);

        // 2. Gemini: 解析合併後的 GPX，並插入使用者定義的名稱。
        final String mergedContent = utf8.decode(mergedGpxBytes, allowMalformed: true);
        final XmlDocument document = XmlDocument.parse(mergedContent);
        final metadata = document.rootElement.findElements('metadata').firstOrNull;

        if (metadata != null) {
          // 移除舊的 name 標籤 (如果存在)
          metadata.children.removeWhere((node) => node is XmlElement && node.name.local == 'name');
          // 插入新的 name 標籤
          metadata.children.insert(0, XmlElement(XmlName('name'), [], [XmlText(event.trackName)]));
        }

        // 3. 將修改後的 XML 轉回 Bytes
        final finalGpxBytes = utf8.encode(document.toXmlString(pretty: true));

        // 4. 發出成功狀態
        emit(GpxMergeSuccess(mergedGpxBytes: finalGpxBytes));
      } catch (e) {
        emit(GpxMergeError(
          '合併或儲存檔案時發生錯誤: $e',
          errorCode: 'merge_save_failed',
        ));
        emit(GpxMergeLoaded(currentFiles));
      }
    }
  }
}
