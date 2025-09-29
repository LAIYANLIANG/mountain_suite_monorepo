// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '登山應用程式';

  @override
  String get trackingFeatureTitle => '軌跡記錄';

  @override
  String get trackingStoppedMessage => '軌跡已停止。';

  @override
  String get startTrackingButton => '開始記錄';

  @override
  String get pauseTrackingButton => '暫停記錄';

  @override
  String get stopTrackingButton => '停止記錄';

  @override
  String get resumeTrackingButton => '繼續記錄';

  @override
  String get defaultTrackName => '我的軌跡';

  @override
  String get trackNameLabel => '軌跡名稱';

  @override
  String get saveTrackButton => '儲存軌跡';

  @override
  String get startNewTrackButton => '開始新軌跡';

  @override
  String get homeScreenTitle => '首頁';

  @override
  String get infoScreenTitle => '資訊';

  @override
  String get gpxPlanningScreenTitle => 'GPX 規劃';

  @override
  String get gpxMergeScreenTitle => 'GPX 合併';

  @override
  String get routeEstimationScreenTitle => '路線估算';

  @override
  String get equipmentChecklistScreenTitle => '裝備檢查表';

  @override
  String get authScreenTitle => '帳戶管理';

  @override
  String get socialFeedTitle => '社群動態';
}
