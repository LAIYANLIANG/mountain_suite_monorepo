import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mountain_hiking_app/src/providers/locale_provider.dart';
import 'package:mountain_hiking_app/main.dart'; // We need AppProvider
import 'package:mountain_hiking_app/generated/app_localizations.dart';

// FIX: Create a helper function to wrap widgets in a full app environment for testing.
Widget createTestApp(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
      // Add other providers from AppProvider if they are needed for the test.
    ],
    child: Builder(
      builder: (context) {
        // Access the provider to set the locale for the test.
        final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
        localeProvider.setLocale(const Locale('zh')); // Set to Chinese for this test.

        return MaterialApp(
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: child, // The widget to be tested.
        );
      },
    ),
  );
}

void main() {
  testWidgets('HomeScreen renders correctly in offline mode', (WidgetTester tester) async {
    // FIX: Pump the AppProvider within the full test app wrapper.
    await tester.pumpWidget(createTestApp(const AppProvider()));

    // Wait for all frames to settle.
    await tester.pumpAndSettle();

    // Verify that the main screen shows key widgets instead of the counter.
    // FIX: Use the key from AppLocalizations to be locale-independent in the future,
    // but for now, finding the Chinese text will work since we set the locale.
    expect(find.text('開始規劃新路線'), findsOneWidget);
    // FIX: This widget is intentionally hidden in the current version.
    expect(find.text('🔥 本週熱門'), findsNothing);
    expect(find.byIcon(Icons.menu), findsOneWidget); // Find the SpeedDial FAB

    // Verify that the counter text is not present.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);
  });
}