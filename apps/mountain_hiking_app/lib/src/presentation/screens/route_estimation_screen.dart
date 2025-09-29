import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/route_estimation/route_estimation_bloc.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/app_speed_dial.dart';
import 'package:mountain_hiking_app/generated/app_localizations.dart';

class RouteEstimationScreen extends StatelessWidget {
  const RouteEstimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RouteEstimationBloc()..add(LoadSavedData()),
      child: const _RouteEstimationView(),
    );
  }
}

class _RouteEstimationView extends StatefulWidget {
  const _RouteEstimationView();

  @override
  State<_RouteEstimationView> createState() => _RouteEstimationViewState();
}

class _RouteEstimationViewState extends State<_RouteEstimationView> {
  final _qixingController = TextEditingController();
  final _tianmuController = TextEditingController();
  final _yushanController = TextEditingController();
  final _hehuanController = TextEditingController();
  final TextEditingController _inactivityMonthsController = TextEditingController();

  int? _breathingLevel;
  int _inactivityMonths = 0;

  @override
  void dispose() {
    _qixingController.dispose();
    _tianmuController.dispose();
    _yushanController.dispose();
    _hehuanController.dispose();
    _inactivityMonthsController.dispose();
    super.dispose();
  }

  void _onCalculatePressed() {
    final Map<String, String> timeInputs = {
      RouteEstimationBloc.qixingTimeKey: _getProcessedTime(_qixingController.text, RouteEstimationBloc.qixingStandardTime),
      RouteEstimationBloc.tianmuTimeKey: _getProcessedTime(_tianmuController.text, RouteEstimationBloc.tianmuStandardTime),
      RouteEstimationBloc.yushanTimeKey: _getProcessedTime(_yushanController.text, RouteEstimationBloc.yushanStandardTime),
      RouteEstimationBloc.hehuanTimeKey: _getProcessedTime(_hehuanController.text, RouteEstimationBloc.hehuanStandardTime),
    };

    double inactivityMultiplier = 1.0;
    for (int i = 0; i < _inactivityMonths; i++) {
      inactivityMultiplier *= 1.1;
    }

    context.read<RouteEstimationBloc>().add(CalculationRequested(timeInputs, _breathingLevel ?? 3, inactivityMultiplier: inactivityMultiplier));
  }

  String _getProcessedTime(String inputText, int standardTime) {
    if (inputText.isEmpty) {
      return (standardTime * 1.2).round().toString();
    }
    return inputText;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.routeEstimationScreenTitle),
      ),
      floatingActionButton: const AppSpeedDial(),
      body: BlocConsumer<RouteEstimationBloc, RouteEstimationState>(
        listener: (context, state) {
          if (state is RouteEstimationLoaded) {
            if (_qixingController.text != state.timeInputs[RouteEstimationBloc.qixingTimeKey]) {
              _qixingController.text = state.timeInputs[RouteEstimationBloc.qixingTimeKey]!;
            }
            if (_tianmuController.text != state.timeInputs[RouteEstimationBloc.tianmuTimeKey]) {
              _tianmuController.text = state.timeInputs[RouteEstimationBloc.tianmuTimeKey]!;
            }
            if (_yushanController.text != state.timeInputs[RouteEstimationBloc.yushanTimeKey]) {
              _yushanController.text = state.timeInputs[RouteEstimationBloc.yushanTimeKey]!;
            }
            if (_hehuanController.text != state.timeInputs[RouteEstimationBloc.hehuanTimeKey]) {
              _hehuanController.text = state.timeInputs[RouteEstimationBloc.hehuanTimeKey]!;
            }
            _breathingLevel = state.breathingLevel;
          }
        },
        builder: (context, state) {
          if (state is RouteEstimationInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RouteEstimationLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTimeInputRow(
                    name: l10n.estimation_routeQixing,
                    standardTime: RouteEstimationBloc.qixingStandardTime,
                    controller: _qixingController,
                  ),
                  _buildTimeInputRow(
                    name: l10n.estimation_routeTianmu,
                    standardTime: RouteEstimationBloc.tianmuStandardTime,
                    controller: _tianmuController,
                  ),
                  _buildTimeInputRow(
                    name: l10n.estimation_routeYushan,
                    standardTime: RouteEstimationBloc.yushanStandardTime,
                    controller: _yushanController,
                  ),
                  _buildTimeInputRow(
                    name: l10n.estimation_routeHehuan,
                    standardTime: RouteEstimationBloc.hehuanStandardTime,
                    controller: _hehuanController,
                  ),
                  const SizedBox(height: 24),
                  Text(l10n.estimation_breathingLevelQuestion, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  _buildBreathingRadioGroup(state.breathingLevel),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _inactivityMonthsController,
                    decoration: InputDecoration(
                      labelText: l10n.estimation_inactivityLabel,
                      border: const OutlineInputBorder(),
                      suffixText: l10n.estimation_monthsUnit,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() {
                        _inactivityMonths = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _onCalculatePressed,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: Text(l10n.estimation_calculateButton),
                  ),
                  const SizedBox(height: 24),
                  if (state.calculatedCoefficient != null)
                    _buildResultCard(state.calculatedCoefficient!),
                ],
              ),
            );
          }
          return const Center(child: Text('發生錯誤'));
        },
      ),
    );
  }

  Widget _buildTimeInputRow({
    required String name,
    required int standardTime,
    required TextEditingController controller,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(name)),
          Expanded(flex: 2, child: Text('$standardTime ${l10n.estimation_minutesUnit}', textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: l10n.estimation_yourTimeHint,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingRadioGroup(int groupValue) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        RadioListTile<int>(
          title: Text(l10n.estimation_breathingLevel1),
          value: 1,
          groupValue: groupValue,
          onChanged: (value) {
            context.read<RouteEstimationBloc>().add(BreathingLevelChanged(value!));
          },
        ),
        RadioListTile<int>(
          title: Text(l10n.estimation_breathingLevel3),
          value: 3,
          groupValue: groupValue,
          onChanged: (value) {
            context.read<RouteEstimationBloc>().add(BreathingLevelChanged(value!));
          },
        ),
        RadioListTile<int>(
          title: Text(l10n.estimation_breathingLevel5),
          value: 5,
          groupValue: groupValue,
          onChanged: (value) {
            context.read<RouteEstimationBloc>().add(BreathingLevelChanged(value!));
          },
        ),
      ],
    );
  }

  Widget _buildResultCard(double coefficient) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              l10n.estimation_resultTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              coefficient.toStringAsFixed(2),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.green.shade700),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.estimation_resultDescription,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.estimation_resultWarning,
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade600), textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}