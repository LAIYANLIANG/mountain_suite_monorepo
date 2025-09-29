import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('ja'),
    Locale('ko'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// 應用程式標題
  ///
  /// In zh, this message translates to:
  /// **'登山應用程式'**
  String get appTitle;

  /// No description provided for @homeScreenTitle.
  ///
  /// In zh, this message translates to:
  /// **'首頁'**
  String get homeScreenTitle;

  /// No description provided for @infoScreenTitle.
  ///
  /// In zh, this message translates to:
  /// **'參考資訊'**
  String get infoScreenTitle;

  /// No description provided for @gpxPlanningScreenTitle.
  ///
  /// In zh, this message translates to:
  /// **'GPX 地圖規劃'**
  String get gpxPlanningScreenTitle;

  /// No description provided for @gpxMergeScreenTitle.
  ///
  /// In zh, this message translates to:
  /// **'GPX 整併功能'**
  String get gpxMergeScreenTitle;

  /// No description provided for @routeEstimationScreenTitle.
  ///
  /// In zh, this message translates to:
  /// **'路程評估'**
  String get routeEstimationScreenTitle;

  /// No description provided for @equipmentChecklistScreenTitle.
  ///
  /// In zh, this message translates to:
  /// **'裝備盤點表'**
  String get equipmentChecklistScreenTitle;

  /// No description provided for @gpxLibraryScreenTitle.
  ///
  /// In zh, this message translates to:
  /// **'GPX 地圖庫'**
  String get gpxLibraryScreenTitle;

  /// No description provided for @authScreenTitle.
  ///
  /// In zh, this message translates to:
  /// **'帳戶管理'**
  String get authScreenTitle;

  /// No description provided for @socialFeedTitle.
  ///
  /// In zh, this message translates to:
  /// **'社群動態'**
  String get socialFeedTitle;

  /// No description provided for @trackingFeatureTitle.
  ///
  /// In zh, this message translates to:
  /// **'記錄你的行走軌跡'**
  String get trackingFeatureTitle;

  /// No description provided for @trackingStoppedMessage.
  ///
  /// In zh, this message translates to:
  /// **'軌跡已停止。'**
  String get trackingStoppedMessage;

  /// No description provided for @startTrackingButton.
  ///
  /// In zh, this message translates to:
  /// **'開始記錄'**
  String get startTrackingButton;

  /// No description provided for @pauseTrackingButton.
  ///
  /// In zh, this message translates to:
  /// **'暫停記錄'**
  String get pauseTrackingButton;

  /// No description provided for @stopTrackingButton.
  ///
  /// In zh, this message translates to:
  /// **'停止記錄'**
  String get stopTrackingButton;

  /// No description provided for @resumeTrackingButton.
  ///
  /// In zh, this message translates to:
  /// **'繼續記錄'**
  String get resumeTrackingButton;

  /// No description provided for @defaultTrackName.
  ///
  /// In zh, this message translates to:
  /// **'我的軌跡'**
  String get defaultTrackName;

  /// No description provided for @trackNameLabel.
  ///
  /// In zh, this message translates to:
  /// **'軌跡名稱'**
  String get trackNameLabel;

  /// No description provided for @saveTrackButton.
  ///
  /// In zh, this message translates to:
  /// **'儲存軌跡'**
  String get saveTrackButton;

  /// No description provided for @startNewTrackButton.
  ///
  /// In zh, this message translates to:
  /// **'開始新軌跡'**
  String get startNewTrackButton;

  /// No description provided for @home_startPlanning.
  ///
  /// In zh, this message translates to:
  /// **'開始規劃新路線'**
  String get home_startPlanning;

  /// No description provided for @checklist_personalGear.
  ///
  /// In zh, this message translates to:
  /// **'個人裝備'**
  String get checklist_personalGear;

  /// No description provided for @checklist_groupGear.
  ///
  /// In zh, this message translates to:
  /// **'團體裝備'**
  String get checklist_groupGear;

  /// No description provided for @checklist_baseGear.
  ///
  /// In zh, this message translates to:
  /// **'基本裝備'**
  String get checklist_baseGear;

  /// No description provided for @checklist_technicalGear.
  ///
  /// In zh, this message translates to:
  /// **'技術/雪季器材'**
  String get checklist_technicalGear;

  /// No description provided for @checklist_otherGear.
  ///
  /// In zh, this message translates to:
  /// **'其他物品'**
  String get checklist_otherGear;

  /// No description provided for @checklist_totalWeight.
  ///
  /// In zh, this message translates to:
  /// **'總重量'**
  String get checklist_totalWeight;

  /// No description provided for @checklist_quantity.
  ///
  /// In zh, this message translates to:
  /// **'數量'**
  String get checklist_quantity;

  /// No description provided for @checklist_weightGrams.
  ///
  /// In zh, this message translates to:
  /// **'重量(g)'**
  String get checklist_weightGrams;

  /// No description provided for @checklist_snowEssential.
  ///
  /// In zh, this message translates to:
  /// **'雪季必備'**
  String get checklist_snowEssential;

  /// No description provided for @estimation_routeQixing.
  ///
  /// In zh, this message translates to:
  /// **'陽明山七星山主峰來回'**
  String get estimation_routeQixing;

  /// No description provided for @estimation_routeTianmu.
  ///
  /// In zh, this message translates to:
  /// **'天母古道'**
  String get estimation_routeTianmu;

  /// No description provided for @estimation_routeYushan.
  ///
  /// In zh, this message translates to:
  /// **'玉山主峰'**
  String get estimation_routeYushan;

  /// No description provided for @estimation_routeHehuan.
  ///
  /// In zh, this message translates to:
  /// **'合歡北峰'**
  String get estimation_routeHehuan;

  /// No description provided for @estimation_yourTimeHint.
  ///
  /// In zh, this message translates to:
  /// **'您的時間'**
  String get estimation_yourTimeHint;

  /// No description provided for @estimation_minutesUnit.
  ///
  /// In zh, this message translates to:
  /// **'分鐘'**
  String get estimation_minutesUnit;

  /// No description provided for @estimation_breathingLevelQuestion.
  ///
  /// In zh, this message translates to:
  /// **'從一樓依自身正常速度爬到五樓的喘度？'**
  String get estimation_breathingLevelQuestion;

  /// No description provided for @estimation_breathingLevel1.
  ///
  /// In zh, this message translates to:
  /// **'1 - 沒感覺'**
  String get estimation_breathingLevel1;

  /// No description provided for @estimation_breathingLevel3.
  ///
  /// In zh, this message translates to:
  /// **'3 - 會累但不喘'**
  String get estimation_breathingLevel3;

  /// No description provided for @estimation_breathingLevel5.
  ///
  /// In zh, this message translates to:
  /// **'5 - 很喘'**
  String get estimation_breathingLevel5;

  /// No description provided for @estimation_inactivityLabel.
  ///
  /// In zh, this message translates to:
  /// **'不活動月數 (例如：3)'**
  String get estimation_inactivityLabel;

  /// No description provided for @estimation_monthsUnit.
  ///
  /// In zh, this message translates to:
  /// **'個月'**
  String get estimation_monthsUnit;

  /// No description provided for @estimation_calculateButton.
  ///
  /// In zh, this message translates to:
  /// **'計算並儲存我的腳程係數'**
  String get estimation_calculateButton;

  /// No description provided for @estimation_resultTitle.
  ///
  /// In zh, this message translates to:
  /// **'您的腳程係數約為'**
  String get estimation_resultTitle;

  /// No description provided for @estimation_resultDescription.
  ///
  /// In zh, this message translates to:
  /// **'(此為相對於上河時間的倍率。例如 1.0 代表與上河時間相同，0.8 代表您走得比上河時間快，1.2 代表您走得比上河時間慢。)'**
  String get estimation_resultDescription;

  /// No description provided for @estimation_resultWarning.
  ///
  /// In zh, this message translates to:
  /// **'提醒：如果一個月內未運動或登山，建議估算時間再加乘 1.1。三個月沒運動則乘以 1.1 的三次方。'**
  String get estimation_resultWarning;

  /// No description provided for @merge_selectButton.
  ///
  /// In zh, this message translates to:
  /// **'選擇 GPX 檔案 (最多3個)'**
  String get merge_selectButton;

  /// No description provided for @merge_mergeButton.
  ///
  /// In zh, this message translates to:
  /// **'合併 GPX 檔案'**
  String get merge_mergeButton;

  /// No description provided for @merge_selectedFilesTitle.
  ///
  /// In zh, this message translates to:
  /// **'已選檔案:'**
  String get merge_selectedFilesTitle;

  /// No description provided for @merge_noFilesSelected.
  ///
  /// In zh, this message translates to:
  /// **'尚未選擇任何檔案。'**
  String get merge_noFilesSelected;

  /// No description provided for @merge_successDialogTitle.
  ///
  /// In zh, this message translates to:
  /// **'合併成功'**
  String get merge_successDialogTitle;

  /// No description provided for @merge_successDialogContent.
  ///
  /// In zh, this message translates to:
  /// **'合併後的 GPX 檔案已儲存至您的地圖庫.\n\n您是否要前往「GPX 地圖規劃」頁面進一步編輯？'**
  String get merge_successDialogContent;

  /// No description provided for @merge_stayHereButton.
  ///
  /// In zh, this message translates to:
  /// **'留在本頁'**
  String get merge_stayHereButton;

  /// No description provided for @merge_goToPlanningButton.
  ///
  /// In zh, this message translates to:
  /// **'前往規劃'**
  String get merge_goToPlanningButton;

  /// No description provided for @merge_errorTooManyFiles.
  ///
  /// In zh, this message translates to:
  /// **'最多只能選擇 3 個檔案。'**
  String get merge_errorTooManyFiles;

  /// No description provided for @merge_errorTooFewFiles.
  ///
  /// In zh, this message translates to:
  /// **'請至少選擇 2 個檔案進行合併。'**
  String get merge_errorTooFewFiles;

  /// No description provided for @merge_errorFileTooLarge.
  ///
  /// In zh, this message translates to:
  /// **'檔案 \"{fileName}\" 過大，超過 1000KB 的限制。'**
  String merge_errorFileTooLarge(String fileName);

  /// No description provided for @merge_errorNotGpx.
  ///
  /// In zh, this message translates to:
  /// **'檔案 \"{fileName}\" 不是 GPX 檔案。'**
  String merge_errorNotGpx(String fileName);

  /// No description provided for @merge_errorGeneric.
  ///
  /// In zh, this message translates to:
  /// **'發生錯誤: {error}'**
  String merge_errorGeneric(String error);

  /// No description provided for @loading.
  ///
  /// In zh, this message translates to:
  /// **'載入中...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In zh, this message translates to:
  /// **'發生錯誤'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In zh, this message translates to:
  /// **'重試'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'確認'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'儲存'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'刪除'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In zh, this message translates to:
  /// **'編輯'**
  String get edit;

  /// No description provided for @search.
  ///
  /// In zh, this message translates to:
  /// **'搜尋'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In zh, this message translates to:
  /// **'篩選'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In zh, this message translates to:
  /// **'排序'**
  String get sort;

  /// No description provided for @share.
  ///
  /// In zh, this message translates to:
  /// **'分享'**
  String get share;

  /// No description provided for @export.
  ///
  /// In zh, this message translates to:
  /// **'匯出'**
  String get export;

  /// No description provided for @import.
  ///
  /// In zh, this message translates to:
  /// **'匯入'**
  String get import;

  /// No description provided for @upload.
  ///
  /// In zh, this message translates to:
  /// **'上傳'**
  String get upload;

  /// No description provided for @download.
  ///
  /// In zh, this message translates to:
  /// **'下載'**
  String get download;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'設定'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In zh, this message translates to:
  /// **'個人檔案'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In zh, this message translates to:
  /// **'登出'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In zh, this message translates to:
  /// **'登入'**
  String get login;

  /// No description provided for @register.
  ///
  /// In zh, this message translates to:
  /// **'註冊'**
  String get register;

  /// No description provided for @welcome.
  ///
  /// In zh, this message translates to:
  /// **'歡迎'**
  String get welcome;

  /// No description provided for @back.
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get back;

  /// No description provided for @next.
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In zh, this message translates to:
  /// **'上一步'**
  String get previous;

  /// No description provided for @done.
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get done;

  /// No description provided for @close.
  ///
  /// In zh, this message translates to:
  /// **'關閉'**
  String get close;

  /// No description provided for @open.
  ///
  /// In zh, this message translates to:
  /// **'開啟'**
  String get open;

  /// No description provided for @yes.
  ///
  /// In zh, this message translates to:
  /// **'是'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In zh, this message translates to:
  /// **'否'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In zh, this message translates to:
  /// **'確定'**
  String get ok;

  /// No description provided for @selectFile.
  ///
  /// In zh, this message translates to:
  /// **'選擇檔案'**
  String get selectFile;

  /// No description provided for @fileSelected.
  ///
  /// In zh, this message translates to:
  /// **'已選擇 {count} 個檔案'**
  String fileSelected(int count);

  /// No description provided for @noFileSelected.
  ///
  /// In zh, this message translates to:
  /// **'未選擇檔案'**
  String get noFileSelected;

  /// No description provided for @fileUploadSuccess.
  ///
  /// In zh, this message translates to:
  /// **'檔案上傳成功'**
  String get fileUploadSuccess;

  /// No description provided for @fileUploadError.
  ///
  /// In zh, this message translates to:
  /// **'檔案上傳失敗'**
  String get fileUploadError;

  /// No description provided for @fileSizeLimit.
  ///
  /// In zh, this message translates to:
  /// **'檔案大小限制：{size}'**
  String fileSizeLimit(String size);

  /// No description provided for @distance.
  ///
  /// In zh, this message translates to:
  /// **'距離'**
  String get distance;

  /// No description provided for @elevation.
  ///
  /// In zh, this message translates to:
  /// **'海拔'**
  String get elevation;

  /// No description provided for @elevationGain.
  ///
  /// In zh, this message translates to:
  /// **'累積爬升'**
  String get elevationGain;

  /// No description provided for @elevationLoss.
  ///
  /// In zh, this message translates to:
  /// **'累積下降'**
  String get elevationLoss;

  /// No description provided for @duration.
  ///
  /// In zh, this message translates to:
  /// **'時間'**
  String get duration;

  /// No description provided for @speed.
  ///
  /// In zh, this message translates to:
  /// **'速度'**
  String get speed;

  /// No description provided for @pace.
  ///
  /// In zh, this message translates to:
  /// **'配速'**
  String get pace;

  /// No description provided for @difficulty.
  ///
  /// In zh, this message translates to:
  /// **'難度'**
  String get difficulty;

  /// No description provided for @easy.
  ///
  /// In zh, this message translates to:
  /// **'簡單'**
  String get easy;

  /// No description provided for @moderate.
  ///
  /// In zh, this message translates to:
  /// **'中等'**
  String get moderate;

  /// No description provided for @hard.
  ///
  /// In zh, this message translates to:
  /// **'困難'**
  String get hard;

  /// No description provided for @expert.
  ///
  /// In zh, this message translates to:
  /// **'專家'**
  String get expert;

  /// No description provided for @startPoint.
  ///
  /// In zh, this message translates to:
  /// **'起點'**
  String get startPoint;

  /// No description provided for @endPoint.
  ///
  /// In zh, this message translates to:
  /// **'終點'**
  String get endPoint;

  /// No description provided for @waypoint.
  ///
  /// In zh, this message translates to:
  /// **'航點'**
  String get waypoint;

  /// No description provided for @currentLocation.
  ///
  /// In zh, this message translates to:
  /// **'目前位置'**
  String get currentLocation;

  /// No description provided for @destination.
  ///
  /// In zh, this message translates to:
  /// **'目的地'**
  String get destination;

  /// No description provided for @route.
  ///
  /// In zh, this message translates to:
  /// **'路線'**
  String get route;

  /// No description provided for @track.
  ///
  /// In zh, this message translates to:
  /// **'軌跡'**
  String get track;

  /// No description provided for @map.
  ///
  /// In zh, this message translates to:
  /// **'地圖'**
  String get map;

  /// No description provided for @satellite.
  ///
  /// In zh, this message translates to:
  /// **'衛星'**
  String get satellite;

  /// No description provided for @terrain.
  ///
  /// In zh, this message translates to:
  /// **'地形'**
  String get terrain;

  /// No description provided for @hybrid.
  ///
  /// In zh, this message translates to:
  /// **'混合'**
  String get hybrid;

  /// No description provided for @weather.
  ///
  /// In zh, this message translates to:
  /// **'天氣'**
  String get weather;

  /// No description provided for @temperature.
  ///
  /// In zh, this message translates to:
  /// **'溫度'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In zh, this message translates to:
  /// **'濕度'**
  String get humidity;

  /// No description provided for @windSpeed.
  ///
  /// In zh, this message translates to:
  /// **'風速'**
  String get windSpeed;

  /// No description provided for @precipitation.
  ///
  /// In zh, this message translates to:
  /// **'降雨機率'**
  String get precipitation;

  /// No description provided for @equipment.
  ///
  /// In zh, this message translates to:
  /// **'裝備'**
  String get equipment;

  /// No description provided for @required.
  ///
  /// In zh, this message translates to:
  /// **'必備'**
  String get required;

  /// No description provided for @optional.
  ///
  /// In zh, this message translates to:
  /// **'選備'**
  String get optional;

  /// No description provided for @quantity.
  ///
  /// In zh, this message translates to:
  /// **'數量'**
  String get quantity;

  /// No description provided for @weight.
  ///
  /// In zh, this message translates to:
  /// **'重量'**
  String get weight;

  /// No description provided for @totalWeight.
  ///
  /// In zh, this message translates to:
  /// **'總重量'**
  String get totalWeight;

  /// No description provided for @checklist.
  ///
  /// In zh, this message translates to:
  /// **'檢查清單'**
  String get checklist;

  /// No description provided for @completed.
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get completed;

  /// No description provided for @incomplete.
  ///
  /// In zh, this message translates to:
  /// **'未完成'**
  String get incomplete;

  /// No description provided for @mergeGpx.
  ///
  /// In zh, this message translates to:
  /// **'合併 GPX'**
  String get mergeGpx;

  /// No description provided for @selectFilesToMerge.
  ///
  /// In zh, this message translates to:
  /// **'選擇要合併的檔案'**
  String get selectFilesToMerge;

  /// No description provided for @mergeSuccess.
  ///
  /// In zh, this message translates to:
  /// **'合併成功'**
  String get mergeSuccess;

  /// No description provided for @mergeError.
  ///
  /// In zh, this message translates to:
  /// **'合併失敗'**
  String get mergeError;

  /// No description provided for @processing.
  ///
  /// In zh, this message translates to:
  /// **'處理中...'**
  String get processing;

  /// No description provided for @aiSuggestion.
  ///
  /// In zh, this message translates to:
  /// **'AI 建議'**
  String get aiSuggestion;

  /// No description provided for @optimizeRoute.
  ///
  /// In zh, this message translates to:
  /// **'優化路線'**
  String get optimizeRoute;

  /// No description provided for @shortestPath.
  ///
  /// In zh, this message translates to:
  /// **'最短路徑'**
  String get shortestPath;

  /// No description provided for @leastElevation.
  ///
  /// In zh, this message translates to:
  /// **'最少爬升'**
  String get leastElevation;

  /// No description provided for @safestRoute.
  ///
  /// In zh, this message translates to:
  /// **'最安全路線'**
  String get safestRoute;

  /// No description provided for @favorites.
  ///
  /// In zh, this message translates to:
  /// **'我的最愛'**
  String get favorites;

  /// No description provided for @addToFavorites.
  ///
  /// In zh, this message translates to:
  /// **'加入最愛'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In zh, this message translates to:
  /// **'移除最愛'**
  String get removeFromFavorites;

  /// No description provided for @favoritesLimit.
  ///
  /// In zh, this message translates to:
  /// **'最愛的上限是4個，請對其中做出斷捨離'**
  String get favoritesLimit;

  /// No description provided for @announcement.
  ///
  /// In zh, this message translates to:
  /// **'官方公告'**
  String get announcement;

  /// No description provided for @news.
  ///
  /// In zh, this message translates to:
  /// **'最新消息'**
  String get news;

  /// No description provided for @notification.
  ///
  /// In zh, this message translates to:
  /// **'通知'**
  String get notification;

  /// No description provided for @message.
  ///
  /// In zh, this message translates to:
  /// **'訊息'**
  String get message;

  /// No description provided for @networkError.
  ///
  /// In zh, this message translates to:
  /// **'網路連線錯誤'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In zh, this message translates to:
  /// **'伺服器錯誤'**
  String get serverError;

  /// No description provided for @unknownError.
  ///
  /// In zh, this message translates to:
  /// **'未知錯誤'**
  String get unknownError;

  /// No description provided for @tryAgainLater.
  ///
  /// In zh, this message translates to:
  /// **'請稍後再試'**
  String get tryAgainLater;

  /// No description provided for @privacyPolicy.
  ///
  /// In zh, this message translates to:
  /// **'隱私政策'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In zh, this message translates to:
  /// **'服務條款'**
  String get termsOfService;

  /// No description provided for @about.
  ///
  /// In zh, this message translates to:
  /// **'關於'**
  String get about;

  /// No description provided for @version.
  ///
  /// In zh, this message translates to:
  /// **'版本'**
  String get version;

  /// No description provided for @contactUs.
  ///
  /// In zh, this message translates to:
  /// **'聯絡我們'**
  String get contactUs;

  /// No description provided for @feedback.
  ///
  /// In zh, this message translates to:
  /// **'意見回饋'**
  String get feedback;

  /// No description provided for @reportBug.
  ///
  /// In zh, this message translates to:
  /// **'回報問題'**
  String get reportBug;

  /// No description provided for @lastUpdated.
  ///
  /// In zh, this message translates to:
  /// **'最後更新'**
  String get lastUpdated;

  /// No description provided for @createdAt.
  ///
  /// In zh, this message translates to:
  /// **'建立時間'**
  String get createdAt;

  /// No description provided for @modifiedAt.
  ///
  /// In zh, this message translates to:
  /// **'修改時間'**
  String get modifiedAt;

  /// No description provided for @syncData.
  ///
  /// In zh, this message translates to:
  /// **'同步資料'**
  String get syncData;

  /// No description provided for @offlineMode.
  ///
  /// In zh, this message translates to:
  /// **'離線模式'**
  String get offlineMode;

  /// No description provided for @onlineMode.
  ///
  /// In zh, this message translates to:
  /// **'線上模式'**
  String get onlineMode;

  /// No description provided for @tutorial.
  ///
  /// In zh, this message translates to:
  /// **'教學'**
  String get tutorial;

  /// No description provided for @help.
  ///
  /// In zh, this message translates to:
  /// **'說明'**
  String get help;

  /// No description provided for @faq.
  ///
  /// In zh, this message translates to:
  /// **'常見問題'**
  String get faq;

  /// No description provided for @guide.
  ///
  /// In zh, this message translates to:
  /// **'使用指南'**
  String get guide;

  /// No description provided for @tips.
  ///
  /// In zh, this message translates to:
  /// **'小提示'**
  String get tips;

  /// No description provided for @shareWith.
  ///
  /// In zh, this message translates to:
  /// **'分享給'**
  String get shareWith;

  /// No description provided for @copyLink.
  ///
  /// In zh, this message translates to:
  /// **'複製連結'**
  String get copyLink;

  /// No description provided for @qrCode.
  ///
  /// In zh, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// No description provided for @scanQrCode.
  ///
  /// In zh, this message translates to:
  /// **'掃描 QR Code'**
  String get scanQrCode;

  /// No description provided for @year.
  ///
  /// In zh, this message translates to:
  /// **'年'**
  String get year;

  /// No description provided for @month.
  ///
  /// In zh, this message translates to:
  /// **'月'**
  String get month;

  /// No description provided for @day.
  ///
  /// In zh, this message translates to:
  /// **'日'**
  String get day;

  /// No description provided for @hour.
  ///
  /// In zh, this message translates to:
  /// **'小時'**
  String get hour;

  /// No description provided for @minute.
  ///
  /// In zh, this message translates to:
  /// **'分鐘'**
  String get minute;

  /// No description provided for @second.
  ///
  /// In zh, this message translates to:
  /// **'秒'**
  String get second;

  /// No description provided for @today.
  ///
  /// In zh, this message translates to:
  /// **'今天'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In zh, this message translates to:
  /// **'昨天'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In zh, this message translates to:
  /// **'明天'**
  String get tomorrow;

  /// No description provided for @thisWeek.
  ///
  /// In zh, this message translates to:
  /// **'本週'**
  String get thisWeek;

  /// No description provided for @lastWeek.
  ///
  /// In zh, this message translates to:
  /// **'上週'**
  String get lastWeek;

  /// No description provided for @thisMonth.
  ///
  /// In zh, this message translates to:
  /// **'本月'**
  String get thisMonth;

  /// No description provided for @lastMonth.
  ///
  /// In zh, this message translates to:
  /// **'上月'**
  String get lastMonth;

  /// No description provided for @male.
  ///
  /// In zh, this message translates to:
  /// **'男性'**
  String get male;

  /// No description provided for @female.
  ///
  /// In zh, this message translates to:
  /// **'女性'**
  String get female;

  /// No description provided for @other.
  ///
  /// In zh, this message translates to:
  /// **'其他'**
  String get other;

  /// No description provided for @age.
  ///
  /// In zh, this message translates to:
  /// **'年齡'**
  String get age;

  /// No description provided for @height.
  ///
  /// In zh, this message translates to:
  /// **'身高'**
  String get height;

  /// No description provided for @weight_unit.
  ///
  /// In zh, this message translates to:
  /// **'體重'**
  String get weight_unit;

  /// No description provided for @experience.
  ///
  /// In zh, this message translates to:
  /// **'經驗'**
  String get experience;

  /// No description provided for @beginner.
  ///
  /// In zh, this message translates to:
  /// **'初學者'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In zh, this message translates to:
  /// **'中級'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In zh, this message translates to:
  /// **'進階'**
  String get advanced;

  /// No description provided for @professional.
  ///
  /// In zh, this message translates to:
  /// **'專業'**
  String get professional;

  /// No description provided for @achievement.
  ///
  /// In zh, this message translates to:
  /// **'成就'**
  String get achievement;

  /// No description provided for @badge.
  ///
  /// In zh, this message translates to:
  /// **'徽章'**
  String get badge;

  /// No description provided for @level.
  ///
  /// In zh, this message translates to:
  /// **'等級'**
  String get level;

  /// No description provided for @points.
  ///
  /// In zh, this message translates to:
  /// **'點數'**
  String get points;

  /// No description provided for @ranking.
  ///
  /// In zh, this message translates to:
  /// **'排名'**
  String get ranking;

  /// No description provided for @leaderboard.
  ///
  /// In zh, this message translates to:
  /// **'排行榜'**
  String get leaderboard;

  /// No description provided for @statistics.
  ///
  /// In zh, this message translates to:
  /// **'統計'**
  String get statistics;

  /// No description provided for @progress.
  ///
  /// In zh, this message translates to:
  /// **'進度'**
  String get progress;

  /// No description provided for @connectionLost.
  ///
  /// In zh, this message translates to:
  /// **'連線中斷'**
  String get connectionLost;

  /// No description provided for @reconnecting.
  ///
  /// In zh, this message translates to:
  /// **'重新連線中...'**
  String get reconnecting;

  /// No description provided for @connected.
  ///
  /// In zh, this message translates to:
  /// **'已連線'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In zh, this message translates to:
  /// **'已斷線'**
  String get disconnected;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'id',
    'ja',
    'ko',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
