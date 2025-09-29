import 'package:equatable/equatable.dart';

// 移除 part of 'gpx_bloc.dart';

abstract class GpxEvent extends Equatable {
  const GpxEvent();

  @override
  List<Object?> get props => [];
}

/// 事件：使用者請求選擇一個檔案
class GpxFilePickRequested extends GpxEvent {
  final int index;

  const GpxFilePickRequested({required this.index});

  @override
  List<Object?> get props => [index];
}

/// 事件：使用者請求移除一個檔案
class GpxFileRemoved extends GpxEvent {
  final int index;

  const GpxFileRemoved({required this.index});

  @override
  List<Object?> get props => [index];
}

/// 事件：使用者請求開始合併檔案
class GpxMergeStarted extends GpxEvent {}