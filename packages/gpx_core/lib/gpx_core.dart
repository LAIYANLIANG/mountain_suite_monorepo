// 這個檔案是 gpx_core 套件的「公開 API」。
// 它會匯出所有需要被外部（如 gpx_merger_app）使用的類別。

export 'src/repository/gpx_repository.dart';
export 'src/bloc/gpx_bloc.dart';
export 'src/bloc/gpx_event.dart';
export 'src/bloc/gpx_state.dart';
export 'src/models/gpx.dart';
export 'src/models/gpx_writer.dart';
export 'src/models/gpx_reader.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

