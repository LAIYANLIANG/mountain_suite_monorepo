import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
@immutable
abstract class RouteEstimationEvent {}

class LoadSavedData extends RouteEstimationEvent {}

class CalculationRequested extends RouteEstimationEvent {
  final Map<String, String> timeInputs;
  final int breathingLevel;
  final double inactivityMultiplier;

  CalculationRequested(this.timeInputs, this.breathingLevel, {this.inactivityMultiplier = 1.0});
}

class BreathingLevelChanged extends RouteEstimationEvent {
  final int newLevel;

  BreathingLevelChanged(this.newLevel);
}

// States
@immutable
abstract class RouteEstimationState {}

class RouteEstimationInitial extends RouteEstimationState {}

class RouteEstimationLoaded extends RouteEstimationState {
  final Map<String, String> timeInputs;
  final int breathingLevel;
  final double? calculatedCoefficient;

  RouteEstimationLoaded({
    required this.timeInputs,
    required this.breathingLevel,
    this.calculatedCoefficient,
  });

  RouteEstimationLoaded copyWith({
    Map<String, String>? timeInputs,
    int? breathingLevel,
    double? calculatedCoefficient,
    bool clearCoefficient = false,
  }) {
    return RouteEstimationLoaded(
      timeInputs: timeInputs ?? this.timeInputs,
      breathingLevel: breathingLevel ?? this.breathingLevel,
      calculatedCoefficient: clearCoefficient ? null : calculatedCoefficient ?? this.calculatedCoefficient,
    );
  }
}


class RouteEstimationBloc extends Bloc<RouteEstimationEvent, RouteEstimationState> {
  // Keys for SharedPreferences
  static const String qixingTimeKey = 'qixingTime';
  static const String tianmuTimeKey = 'tianmuTime';
  static const String yushanTimeKey = 'yushanTime';
  static const String hehuanTimeKey = 'hehuanTime';
  static const String breathingLevelKey = 'breathingLevel';
  static const String coefficientKey = 'coefficient';

  // Standard times in minutes
  static const int qixingStandardTime = 180;
  static const int tianmuStandardTime = 110;
  static const int yushanStandardTime = 240;
  static const int hehuanStandardTime = 120;

  RouteEstimationBloc() : super(RouteEstimationInitial()) {
    on<LoadSavedData>(_onLoadSavedData);
    on<CalculationRequested>(_onCalculationRequested);
    on<BreathingLevelChanged>(_onBreathingLevelChanged);
  }

  Future<void> _onLoadSavedData(LoadSavedData event, Emitter<RouteEstimationState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final timeInputs = {
      qixingTimeKey: prefs.getString(qixingTimeKey) ?? '',
      tianmuTimeKey: prefs.getString(tianmuTimeKey) ?? '',
      yushanTimeKey: prefs.getString(yushanTimeKey) ?? '',
      hehuanTimeKey: prefs.getString(hehuanTimeKey) ?? '',
    };
    final breathingLevel = prefs.getInt(breathingLevelKey) ?? 3;
    final coefficient = prefs.getDouble(coefficientKey);

    emit(RouteEstimationLoaded(
      timeInputs: timeInputs,
      breathingLevel: breathingLevel,
      calculatedCoefficient: coefficient,
    ));
  }

  Future<void> _onCalculationRequested(CalculationRequested event, Emitter<RouteEstimationState> emit) async {
    double totalUserTime = 0;
    double totalStandardTime = 0;

    final Map<String, int> standardTimes = {
      qixingTimeKey: qixingStandardTime,
      tianmuTimeKey: tianmuStandardTime,
      yushanTimeKey: yushanStandardTime,
      hehuanTimeKey: hehuanStandardTime,
    };

    event.timeInputs.forEach((key, value) {
      if (value.isNotEmpty) {
        final userTime = int.tryParse(value);
        if (userTime != null) {
          totalUserTime += userTime;
          totalStandardTime += standardTimes[key]!;
        }
      }
    });

    if (totalStandardTime == 0) {
      // Handle case where no input is given, maybe emit an error or just clear the coefficient
      if (state is RouteEstimationLoaded) {
        final currentState = state as RouteEstimationLoaded;
        emit(currentState.copyWith(clearCoefficient: true));
      }
      return;
    }

    double newCoefficient = totalUserTime / totalStandardTime;

    // Apply inactivity multiplier
    newCoefficient *= event.inactivityMultiplier;

    // Save the new data
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(breathingLevelKey, event.breathingLevel);
    await prefs.setDouble(coefficientKey, newCoefficient);
    event.timeInputs.forEach((key, value) async {
      await prefs.setString(key, value);
    });

    // Emit the new state
    emit(RouteEstimationLoaded(
      timeInputs: event.timeInputs,
      breathingLevel: event.breathingLevel,
      calculatedCoefficient: newCoefficient,
    ));
  }

  void _onBreathingLevelChanged(BreathingLevelChanged event, Emitter<RouteEstimationState> emit) {
    if (state is RouteEstimationLoaded) {
      final currentState = state as RouteEstimationLoaded;
      emit(currentState.copyWith(breathingLevel: event.newLevel));
    }
  }
}
