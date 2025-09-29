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
  String get homeScreenTitle => 'Home';

  @override
  String get infoScreenTitle => 'Information';

  @override
  String get gpxPlanningScreenTitle => 'GPX Map Planning';

  @override
  String get gpxMergeScreenTitle => 'GPX Merge';

  @override
  String get routeEstimationScreenTitle => 'Route Estimation';

  @override
  String get equipmentChecklistScreenTitle => 'Equipment Checklist';

  @override
  String get gpxLibraryScreenTitle => 'GPX Library';

  @override
  String get authScreenTitle => 'Account Management';

  @override
  String get socialFeedTitle => 'Social Feed';

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
  String get home_startPlanning => 'Start Planning New Route';

  @override
  String get checklist_personalGear => 'Personal Gear';

  @override
  String get checklist_groupGear => 'Group Gear';

  @override
  String get checklist_baseGear => 'Base Gear';

  @override
  String get checklist_technicalGear => 'Technical/Snow Gear';

  @override
  String get checklist_otherGear => 'Other Items';

  @override
  String get checklist_totalWeight => 'Total Weight';

  @override
  String get checklist_quantity => 'Qty';

  @override
  String get checklist_weightGrams => 'Weight(g)';

  @override
  String get checklist_snowEssential => 'Snow Season Essential';

  @override
  String get estimation_routeQixing => 'Mt. Qixing Main Peak Round Trip';

  @override
  String get estimation_routeTianmu => 'Tianmu Ancient Trail';

  @override
  String get estimation_routeYushan => 'Mt. Jade Main Peak';

  @override
  String get estimation_routeHehuan => 'Mt. Hehuan North Peak';

  @override
  String get estimation_yourTimeHint => 'Your Time';

  @override
  String get estimation_minutesUnit => 'minutes';

  @override
  String get estimation_breathingLevelQuestion =>
      'Breathlessness level climbing from 1st to 5th floor at normal speed?';

  @override
  String get estimation_breathingLevel1 => '1 - No feeling';

  @override
  String get estimation_breathingLevel3 => '3 - Tired but not breathless';

  @override
  String get estimation_breathingLevel5 => '5 - Very breathless';

  @override
  String get estimation_inactivityLabel => 'Months of inactivity (e.g., 3)';

  @override
  String get estimation_monthsUnit => 'months';

  @override
  String get estimation_calculateButton =>
      'Calculate & Save My Pace Coefficient';

  @override
  String get estimation_resultTitle => 'Your Pace Coefficient is approximately';

  @override
  String get estimation_resultDescription =>
      '(This is a multiplier relative to the standard map time. E.g., 1.0 is same as standard, 0.8 is faster, 1.2 is slower.)';

  @override
  String get estimation_resultWarning =>
      'Reminder: If you haven\'t exercised or hiked for a month, it is recommended to multiply the estimated time by 1.1. For three months, multiply by 1.1 cubed.';

  @override
  String get merge_selectButton => 'Select GPX Files (Max 3)';

  @override
  String get merge_mergeButton => 'Merge GPX Files';

  @override
  String get merge_selectedFilesTitle => 'Selected Files:';

  @override
  String get merge_noFilesSelected => 'No files selected yet.';

  @override
  String get merge_successDialogTitle => 'Merge Successful';

  @override
  String get merge_successDialogContent =>
      'The merged GPX file has been saved to your library.\n\nWould you like to go to the GPX Planning page for further editing?';

  @override
  String get merge_stayHereButton => 'Stay Here';

  @override
  String get merge_goToPlanningButton => 'Go to Planning';

  @override
  String get merge_errorTooManyFiles => 'A maximum of 3 files can be selected.';

  @override
  String get merge_errorTooFewFiles =>
      'Please select at least 2 files to merge.';

  @override
  String merge_errorFileTooLarge(String fileName) {
    return 'File \"$fileName\" is too large (limit 1000KB).';
  }

  @override
  String merge_errorNotGpx(String fileName) {
    return 'File \"$fileName\" is not a GPX file.';
  }

  @override
  String merge_errorGeneric(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get share => 'Share';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get upload => 'Upload';

  @override
  String get download => 'Download';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get welcome => 'Welcome';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get done => 'Done';

  @override
  String get close => 'Close';

  @override
  String get open => 'Open';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get selectFile => 'Select File';

  @override
  String fileSelected(int count) {
    return '$count file(s) selected';
  }

  @override
  String get noFileSelected => 'No file selected';

  @override
  String get fileUploadSuccess => 'File uploaded successfully';

  @override
  String get fileUploadError => 'File upload failed';

  @override
  String fileSizeLimit(String size) {
    return 'File size limit: $size';
  }

  @override
  String get distance => 'Distance';

  @override
  String get elevation => 'Elevation';

  @override
  String get elevationGain => 'Elevation Gain';

  @override
  String get elevationLoss => 'Elevation Loss';

  @override
  String get duration => 'Duration';

  @override
  String get speed => 'Speed';

  @override
  String get pace => 'Pace';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get easy => 'Easy';

  @override
  String get moderate => 'Moderate';

  @override
  String get hard => 'Hard';

  @override
  String get expert => 'Expert';

  @override
  String get startPoint => 'Start Point';

  @override
  String get endPoint => 'End Point';

  @override
  String get waypoint => 'Waypoint';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get destination => 'Destination';

  @override
  String get route => 'Route';

  @override
  String get track => 'Track';

  @override
  String get map => 'Map';

  @override
  String get satellite => 'Satellite';

  @override
  String get terrain => 'Terrain';

  @override
  String get hybrid => 'Hybrid';

  @override
  String get weather => 'Weather';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidity => 'Humidity';

  @override
  String get windSpeed => 'Wind Speed';

  @override
  String get precipitation => 'Precipitation';

  @override
  String get equipment => 'Equipment';

  @override
  String get required => 'Required';

  @override
  String get optional => 'Optional';

  @override
  String get quantity => 'Quantity';

  @override
  String get weight => 'Weight';

  @override
  String get totalWeight => 'Total Weight';

  @override
  String get checklist => 'Checklist';

  @override
  String get completed => 'Completed';

  @override
  String get incomplete => 'Incomplete';

  @override
  String get mergeGpx => 'Merge GPX';

  @override
  String get selectFilesToMerge => 'Select files to merge';

  @override
  String get mergeSuccess => 'Merge successful';

  @override
  String get mergeError => 'Merge failed';

  @override
  String get processing => 'Processing...';

  @override
  String get aiSuggestion => 'AI Suggestion';

  @override
  String get optimizeRoute => 'Optimize Route';

  @override
  String get shortestPath => 'Shortest Path';

  @override
  String get leastElevation => 'Least Elevation';

  @override
  String get safestRoute => 'Safest Route';

  @override
  String get favorites => 'Favorites';

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get removeFromFavorites => 'Remove from Favorites';

  @override
  String get favoritesLimit =>
      'Favorites limit is 4, please remove one to add another';

  @override
  String get announcement => 'Announcement';

  @override
  String get news => 'News';

  @override
  String get notification => 'Notification';

  @override
  String get message => 'Message';

  @override
  String get networkError => 'Network connection error';

  @override
  String get serverError => 'Server error';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get tryAgainLater => 'Please try again later';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get feedback => 'Feedback';

  @override
  String get reportBug => 'Report Bug';

  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get createdAt => 'Created At';

  @override
  String get modifiedAt => 'Modified At';

  @override
  String get syncData => 'Sync Data';

  @override
  String get offlineMode => 'Offline Mode';

  @override
  String get onlineMode => 'Online Mode';

  @override
  String get tutorial => 'Tutorial';

  @override
  String get help => 'Help';

  @override
  String get faq => 'FAQ';

  @override
  String get guide => 'User Guide';

  @override
  String get tips => 'Tips';

  @override
  String get shareWith => 'Share with';

  @override
  String get copyLink => 'Copy Link';

  @override
  String get qrCode => 'QR Code';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get year => 'Year';

  @override
  String get month => 'Month';

  @override
  String get day => 'Day';

  @override
  String get hour => 'Hour';

  @override
  String get minute => 'Minute';

  @override
  String get second => 'Second';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get thisWeek => 'This Week';

  @override
  String get lastWeek => 'Last Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get lastMonth => 'Last Month';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get age => 'Age';

  @override
  String get height => 'Height';

  @override
  String get weight_unit => 'Weight';

  @override
  String get experience => 'Experience';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get professional => 'Professional';

  @override
  String get achievement => 'Achievement';

  @override
  String get badge => 'Badge';

  @override
  String get level => 'Level';

  @override
  String get points => 'Points';

  @override
  String get ranking => 'Ranking';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get statistics => 'Statistics';

  @override
  String get progress => 'Progress';

  @override
  String get connectionLost => 'Connection Lost';

  @override
  String get reconnecting => 'Reconnecting...';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';
}
