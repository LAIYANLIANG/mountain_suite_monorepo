// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hiking App';

  @override
  String get trackingFeatureTitle => 'Track Recording';

  @override
  String get trackingStoppedMessage => 'Tracking stopped.';

  @override
  String get startTrackingButton => 'Start Tracking';

  @override
  String get pauseTrackingButton => 'Pause Tracking';

  @override
  String get stopTrackingButton => 'Stop Tracking';

  @override
  String get resumeTrackingButton => 'Resume Tracking';

  @override
  String get defaultTrackName => 'My Track';

  @override
  String get trackNameLabel => 'Track Name';

  @override
  String get saveTrackButton => 'Save Track';

  @override
  String get startNewTrackButton => 'Start New Track';

  @override
  String get homeScreenTitle => 'Home';

  @override
  String get infoScreenTitle => 'Information';

  @override
  String get gpxPlanningScreenTitle => 'GPX Planning';

  @override
  String get gpxMergeScreenTitle => 'GPX Merge';

  @override
  String get routeEstimationScreenTitle => 'Route Estimation';

  @override
  String get equipmentChecklistScreenTitle => 'Equipment Checklist';

  @override
  String get authScreenTitle => 'Account Management';

  @override
  String get socialFeedTitle => 'Social Feed';
}
