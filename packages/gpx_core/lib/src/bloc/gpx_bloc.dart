import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';

// 移除 part 指令，改用 import
import '../repository/gpx_repository.dart';
import 'gpx_event.dart';
import 'gpx_state.dart';

class GpxBloc extends Bloc<GpxEvent, GpxState> {
  GpxBloc({required GpxRepository gpxRepository})
      : _gpxRepository = gpxRepository,
        super(const GpxState()) {
    on<GpxFilePickRequested>(_onFilePickRequested);
    on<GpxFileRemoved>(_onFileRemoved);
    on<GpxMergeStarted>(_onMergeStarted);
  }

  final GpxRepository _gpxRepository;
  static const int maxFiles = 2;

  Future<void> _onFilePickRequested(
    GpxFilePickRequested event,
    Emitter<GpxState> emit,
  ) async {
    // 為了避免在處理中時又選擇檔案，增加狀態檢查
    if (state.status == GpxStatus.loading) return;
    
    try {
      final file = await _gpxRepository.pickAndValidateFile();
      if (file != null) {
        final newFiles = List<PlatformFile>.from(state.files);
        if (event.index < newFiles.length) {
          newFiles[event.index] = file;
        } else if (newFiles.length < maxFiles) {
          newFiles.add(file);
        } else {
          // 如果檔案槽已滿，可以拋出錯誤或忽略
          throw Exception('最多只能選擇 $maxFiles 個檔案');
        }
        emit(state.copyWith(status: GpxStatus.initial, files: newFiles, error: ''));
      }
    } catch (e) {
      emit(state.copyWith(status: GpxStatus.failure, error: e.toString()));
      // 立刻將狀態改回 initial，讓錯誤提示只出現一次
      emit(state.copyWith(status: GpxStatus.initial, error: ''));
    }
  }

  void _onFileRemoved(
    GpxFileRemoved event,
    Emitter<GpxState> emit,
  ) {
    final newFiles = List<PlatformFile>.from(state.files);
    newFiles.removeAt(event.index);
    emit(state.copyWith(files: newFiles));
  }

  Future<void> _onMergeStarted(
    GpxMergeStarted event,
    Emitter<GpxState> emit,
  ) async {
    if (state.files.isEmpty) {
      emit(state.copyWith(
        status: GpxStatus.failure,
        error: '請至少選擇一個 GPX 檔案',
      ));
      emit(state.copyWith(status: GpxStatus.initial, error: ''));
      return;
    }

    emit(state.copyWith(status: GpxStatus.loading));

    try {
      final savedPath = await _gpxRepository.mergeAndSaveGpxFiles(state.files);
      emit(state.copyWith(
        status: GpxStatus.success,
        savedFilePath: savedPath,
        files: [], // 合併成功後清空列表
      ));
      // 立刻將狀態改回 initial，讓成功對話框只出現一次
      emit(state.copyWith(status: GpxStatus.initial, savedFilePath: ''));

    } catch (e) {
      emit(state.copyWith(status: GpxStatus.failure, error: e.toString()));
      emit(state.copyWith(status: GpxStatus.initial, error: ''));
    }
  }
}