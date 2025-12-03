
import 'package:flutter/material.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/main_scaffold.dart';
import 'dart:math'; // For pow function
import 'package:intl/intl.dart'; // For date formatting

class RouteEvaluationScreen extends StatefulWidget {
  const RouteEvaluationScreen({super.key});

  @override
  State<RouteEvaluationScreen> createState() => _RouteEvaluationScreenState();
}

class _RouteEvaluationScreenState extends State<RouteEvaluationScreen> {
  final _formKey = GlobalKey<FormState>();

  // G. 路途評估，七星山改成小油坑上七星山主峰之類的，起/迄點要完整
  final Map<String, Map<String, dynamic>> _routes = {
    '小油坑上七星山主峰': {'avg': 180, 'controller': TextEditingController()},
    '天母古道': {'avg': 110, 'controller': TextEditingController()},
    '玉山主峰': {'avg': 240, 'controller': TextEditingController()},
    '合歡北峰': {'avg': 120, 'controller': TextEditingController()},
  };

  double? _shangheCoefficient; // Initial coefficient before exercise multiplier
  double? _finalShangheCoefficient; // Final coefficient after exercise multiplier
  int _breathlessnessLevel = 3; // Default value for the dropdown
  DateTime? _lastExerciseDate; // New: Last exercise date
  int _monthsSinceLastExercise = 0; // New: Months since last exercise

  @override
  void dispose() {
    for (var route in _routes.values) {
      route['controller'].dispose();
    }
    super.dispose();
  }

  void _calculateShanghe() {
    double totalUserTime = 0;
    double totalAvgTime = 0;

    _routes.forEach((key, value) {
      final avgTime = value['avg'] as int;
      final userInput = int.tryParse(value['controller'].text);
      
      final userTime = userInput ?? (avgTime * 1.2);

      // Only include routes where user provided input or it's a default value
      // The original spec implies summing up all 4 routes for the coefficient calculation
      totalUserTime += userTime;
      totalAvgTime += avgTime.toDouble(); // Ensure double for division
    });

    if (totalAvgTime > 0) {
      double baseCoefficient = totalUserTime / totalAvgTime;

      // Calculate months since last exercise
      if (_lastExerciseDate != null) {
        final now = DateTime.now();
        _monthsSinceLastExercise = (now.year - _lastExerciseDate!.year) * 12 +
            now.month - _lastExerciseDate!.month;
        // Ensure it's at least 0
        if (_monthsSinceLastExercise < 0) _monthsSinceLastExercise = 0;
      } else {
        _monthsSinceLastExercise = 0; // No date selected, no multiplier
      }

      double exerciseMultiplier = 1.0;
      if (_monthsSinceLastExercise > 0) {
        exerciseMultiplier = pow(1.1, _monthsSinceLastExercise).toDouble();
      }

      setState(() {
        _shangheCoefficient = baseCoefficient;
        _finalShangheCoefficient = baseCoefficient * exerciseMultiplier;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastExerciseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _lastExerciseDate) {
      setState(() {
        _lastExerciseDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: AppBar(
        title: const Text('路程評估'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '請輸入您過去的登山時間（分鐘），若留空將以平均時間的1.2倍計算。',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ..._routes.entries.map((entry) {
                return _buildRouteInputField(
                  routeName: entry.key,
                  avgTime: entry.value['avg'],
                  controller: entry.value['controller'],
                );
              }),
              const SizedBox(height: 20),
              _buildBreathlessnessInput(), // Interactive dropdown
              const SizedBox(height: 20),
              _buildLastExerciseDateInput(context), // New: Last exercise date input
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _calculateShanghe,
                child: const Text('計算我的上河時間係數'),
              ),
              const SizedBox(height: 30),
              if (_finalShangheCoefficient != null) _buildResultSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteInputField({
    required String routeName,
    required int avgTime,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(routeName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('平均: $avgTime 分鐘'),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '您的時間',
                hintText: '分鐘',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreathlessnessInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '從一樓依自身正常速度爬到五樓的喘度：',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          initialValue: _breathlessnessLevel,
          items: const [
            DropdownMenuItem(value: 1, child: Text('1 - 沒感覺')),
            DropdownMenuItem(value: 2, child: Text('2 - 有點喘')),
            DropdownMenuItem(value: 3, child: Text('3 - 會累但不喘')),
            DropdownMenuItem(value: 4, child: Text('4 - 有點累且喘')),
            DropdownMenuItem(value: 5, child: Text('5 - 很喘')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _breathlessnessLevel = value;
              });
            }
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildLastExerciseDateInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '上次運動或登山日期 (選填)：',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: true,
          controller: TextEditingController(
            text: _lastExerciseDate == null
                ? ''
                : DateFormat('yyyy/MM/dd').format(_lastExerciseDate!),
          ),
          decoration: InputDecoration(
            labelText: '選擇日期',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
          onTap: () => _selectDate(context),
        ),
      ],
    );
  }

  Widget _buildResultSection() {
    return Column(
      children: [
        const Text(
          '您的上河時間係數約為：',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          _finalShangheCoefficient!.toStringAsFixed(2),
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        if (_monthsSinceLastExercise > 0)
          Column(
            children: [
              Text(
                '註：您已超過 $_monthsSinceLastExercise 個月未運動，建議估算時間加乘 ${pow(1.1, _monthsSinceLastExercise).toStringAsFixed(2)} 倍。',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '上述時間僅參考使用，山上路況與氣侯複雜，請審慎評估個人情況',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          )
        else
          Column(
            children: [
              const Text(
                '註：如果一個月內未運動或登山，建議估算時間再加乘1.1倍。',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                '上述時間僅參考使用，山上路況與氣侯複雜，請審慎評估個人情況',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
      ],
    );
  }
}
