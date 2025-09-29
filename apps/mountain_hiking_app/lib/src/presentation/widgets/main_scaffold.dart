
// Updated by Gemini on 2025-08-31. Replaced with reference file to fix issues.
import 'package:flutter/material.dart';
import 'package:mountain_hiking_app/src/presentation/widgets/app_speed_dial.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton; // Added
  final FloatingActionButtonLocation? floatingActionButtonLocation; // Added

  const MainScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton, // Added
    this.floatingActionButtonLocation, // Added
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton ?? const AppSpeedDial(), // Use provided or default
      floatingActionButtonLocation: floatingActionButtonLocation, // Use provided
    );
  }
}
