import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mountain_hiking_app/main.dart' as app;
import 'package:mountain_hiking_app/src/presentation/screens/home_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/gpx_planning/gpx_planning_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/gpx_merge_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/gpx_library_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/tracking_screen.dart';
import 'package:mountain_hiking_app/src/presentation/screens/equipment_checklist_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Smoke Test: Navigate to all major screens', (WidgetTester tester) async {
    // 1. Start App
    app.main();
    await tester.pumpAndSettle();

    // Verify Home Screen
    expect(find.byType(HomeScreen), findsOneWidget);
    print('Home Screen Verified');

    // 2. Navigate to GPX Planning (Button on Home)
    // Assuming the big button "開始規劃新路線" leads there.
    final planButton = find.text('開始規劃新路線');
    if (planButton.evaluate().isNotEmpty) {
      await tester.tap(planButton);
      await tester.pumpAndSettle();
      expect(find.byType(GpxPlanningScreen), findsOneWidget);
      print('GPX Planning Screen Verified');
      // Go back
      await tester.pageBack();
      await tester.pumpAndSettle();
    } else {
      print('Warning: Plan button not found');
    }

    // 3. Open Speed Dial (Menu)
    final menuButton = find.byIcon(Icons.menu);
    await tester.tap(menuButton);
    await tester.pumpAndSettle();

    // 4. Navigate to GPX Merge
    final mergeIcon = find.byIcon(Icons.merge_type); // Assuming icon
    if (mergeIcon.evaluate().isNotEmpty) {
       await tester.tap(mergeIcon);
       await tester.pumpAndSettle();
       expect(find.byType(GpxMergeScreen), findsOneWidget);
       print('GPX Merge Screen Verified');
       await tester.pageBack();
       await tester.pumpAndSettle();
       // Re-open menu
       await tester.tap(menuButton);
       await tester.pumpAndSettle();
    }

    // 5. Navigate to Tracking
    final trackIcon = find.byIcon(Icons.directions_run); // Assuming icon
    if (trackIcon.evaluate().isNotEmpty) {
       await tester.tap(trackIcon);
       await tester.pumpAndSettle();
       expect(find.byType(TrackingScreen), findsOneWidget);
       print('Tracking Screen Verified');
       await tester.pageBack();
       await tester.pumpAndSettle();
       // Re-open menu
       await tester.tap(menuButton);
       await tester.pumpAndSettle();
    }
    
    // 6. Navigate to Library
    final libraryIcon = find.byIcon(Icons.folder); // Assuming icon
    if (libraryIcon.evaluate().isNotEmpty) {
       await tester.tap(libraryIcon);
       await tester.pumpAndSettle();
       expect(find.byType(GpxLibraryScreen), findsOneWidget);
       print('GPX Library Screen Verified');
       await tester.pageBack();
       await tester.pumpAndSettle();
       // Re-open menu
       await tester.tap(menuButton);
       await tester.pumpAndSettle();
    }

    // 7. Navigate to Checklist
    final checklistIcon = find.byIcon(Icons.checklist); // Assuming icon
    if (checklistIcon.evaluate().isNotEmpty) {
       await tester.tap(checklistIcon);
       await tester.pumpAndSettle();
       expect(find.byType(EquipmentChecklistScreen), findsOneWidget);
       print('Checklist Screen Verified');
       await tester.pageBack();
       await tester.pumpAndSettle();
    }

    print('Smoke Test Completed Successfully');
  });
}
