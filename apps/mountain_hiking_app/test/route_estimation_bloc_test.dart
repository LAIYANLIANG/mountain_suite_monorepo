import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mountain_hiking_app/src/business_logic/route_estimation/route_estimation_bloc.dart';

// Mock for SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('RouteEstimationBloc', () {
    late RouteEstimationBloc routeEstimationBloc;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      // Mock the behavior of SharedPreferences.getInstance()
      SharedPreferences.setMockInitialValues({});
      routeEstimationBloc = RouteEstimationBloc();
    });

    tearDown(() {
      routeEstimationBloc.close();
    });

    test('initial state is RouteEstimationInitial', () {
      expect(routeEstimationBloc.state, isA<RouteEstimationInitial>());
    });

    blocTest<RouteEstimationBloc, RouteEstimationState>(
      'emits [RouteEstimationLoaded] with empty values when LoadSavedData is called on empty prefs',
      build: () {
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);
        when(() => mockSharedPreferences.getInt(any())).thenReturn(null);
        when(() => mockSharedPreferences.getDouble(any())).thenReturn(null);
        return routeEstimationBloc;
      },
      act: (bloc) => bloc.add(LoadSavedData()),
      expect: () => [
        isA<RouteEstimationLoaded>()
            .having((state) => state.timeInputs.values.every((v) => v.isEmpty), 'all time inputs are empty', true)
            .having((state) => state.breathingLevel, 'breathingLevel', 3)
            .having((state) => state.calculatedCoefficient, 'calculatedCoefficient', null),
      ],
    );

    blocTest<RouteEstimationBloc, RouteEstimationState>(
      'emits [RouteEstimationLoaded] with calculated coefficient when CalculationRequested is added',
      build: () => routeEstimationBloc,
      act: (bloc) {
        // Simulate some user input
        final timeInputs = {
          RouteEstimationBloc.qixingTimeKey: '200', // User is slower
          RouteEstimationBloc.tianmuTimeKey: '100', // User is faster
        };
        bloc.add(CalculationRequested(timeInputs, 3, inactivityMultiplier: 1.0));
      },
      expect: () {
        // Calculation:
        // totalUserTime = 200 + 100 = 300
        // totalStandardTime = 180 (Qixing) + 110 (Tianmu) = 290
        // coefficient = 300 / 290 = 1.03448...
        const expectedCoefficient = 300.0 / 290.0;

        return [
          isA<RouteEstimationLoaded>()
              .having((state) => state.calculatedCoefficient, 'calculatedCoefficient', closeTo(expectedCoefficient, 0.001))
              .having((state) => state.breathingLevel, 'breathingLevel', 3)
        ];
      },
    );
    
    blocTest<RouteEstimationBloc, RouteEstimationState>(
      'emits [RouteEstimationLoaded] with inactivity multiplier applied',
      build: () => routeEstimationBloc,
      act: (bloc) {
        final timeInputs = {
          RouteEstimationBloc.qixingTimeKey: '180', // Same as standard
        };
        // Simulate 2 months of inactivity (1.1 * 1.1)
        bloc.add(CalculationRequested(timeInputs, 3, inactivityMultiplier: 1.21));
      },
      expect: () {
        // Calculation:
        // base coefficient = 180 / 180 = 1.0
        // final coefficient = 1.0 * 1.21 = 1.21
        const expectedCoefficient = 1.21;

        return [
          isA<RouteEstimationLoaded>()
              .having((state) => state.calculatedCoefficient, 'calculatedCoefficient', closeTo(expectedCoefficient, 0.001))
        ];
      },
    );
  });
}
