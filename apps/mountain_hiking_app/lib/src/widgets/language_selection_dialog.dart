import 'package:flutter/material.dart';
import 'package:mountain_hiking_app/generated/app_localizations.dart';
import 'package:mountain_hiking_app/src/providers/locale_provider.dart';
import 'package:provider/provider.dart';

Future<void> showLanguageSelectionDialog(BuildContext context) {
  // [FEATURE] Map of language codes to their native names for display.
  // This ensures that each language option is shown in its own script.
  const Map<String, String> languageNames = {
    'en': 'English',
    'zh': '中文 (繁體)',
    'ja': '日本語',
    'ko': '한국어',
    'vi': 'Tiếng Việt',
    'id': 'Bahasa Indonesia',
  };

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

      return AlertDialog(
        title: const Text('Select Language / 選擇語言'), // Title in English and Chinese for clarity
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLocalizations.supportedLocales.map((locale) {
              // Get the native name from the map, with a fallback to the language code itself.
              final displayName = languageNames[locale.languageCode] ?? locale.languageCode;
              return ListTile(
                title: Text(displayName),
                onTap: () {
                  localeProvider.setLocale(locale);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}
