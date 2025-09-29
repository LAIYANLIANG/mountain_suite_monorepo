import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

// 移除 part of 'gpx_bloc.dart';

enum GpxStatus { initial, loading, success, failure }

class GpxState extends Equatable {
  const GpxState({
    this.status = GpxStatus.initial,
    this.files = const [],
    this.error = '',
    this.savedFilePath = '',
  });

  final GpxStatus status;
  final List<PlatformFile> files;
  final String error;
  final String savedFilePath;

  GpxState copyWith({
    GpxStatus? status,
    List<PlatformFile>? files,
    String? error,
    String? savedFilePath,
  }) {
    return GpxState(
      status: status ?? this.status,
      files: files ?? this.files,
      error: error ?? this.error,
      savedFilePath: savedFilePath ?? this.savedFilePath,
    );
  }

  @override
  List<Object> get props => [status, files, error, savedFilePath];
}