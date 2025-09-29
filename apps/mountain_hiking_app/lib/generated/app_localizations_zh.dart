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
  String get homeScreenTitle => '首頁';

  @override
  String get infoScreenTitle => '參考資訊';

  @override
  String get gpxPlanningScreenTitle => 'GPX 地圖規劃';

  @override
  String get gpxMergeScreenTitle => 'GPX 整併功能';

  @override
  String get routeEstimationScreenTitle => '路程評估';

  @override
  String get equipmentChecklistScreenTitle => '裝備盤點表';

  @override
  String get gpxLibraryScreenTitle => 'GPX 地圖庫';

  @override
  String get authScreenTitle => '帳戶管理';

  @override
  String get socialFeedTitle => '社群動態';

  @override
  String get trackingFeatureTitle => '記錄你的行走軌跡';

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
  String get home_startPlanning => '開始規劃新路線';

  @override
  String get checklist_personalGear => '個人裝備';

  @override
  String get checklist_groupGear => '團體裝備';

  @override
  String get checklist_baseGear => '基本裝備';

  @override
  String get checklist_technicalGear => '技術/雪季器材';

  @override
  String get checklist_otherGear => '其他物品';

  @override
  String get checklist_totalWeight => '總重量';

  @override
  String get checklist_quantity => '數量';

  @override
  String get checklist_weightGrams => '重量(g)';

  @override
  String get checklist_snowEssential => '雪季必備';

  @override
  String get estimation_routeQixing => '陽明山七星山主峰來回';

  @override
  String get estimation_routeTianmu => '天母古道';

  @override
  String get estimation_routeYushan => '玉山主峰';

  @override
  String get estimation_routeHehuan => '合歡北峰';

  @override
  String get estimation_yourTimeHint => '您的時間';

  @override
  String get estimation_minutesUnit => '分鐘';

  @override
  String get estimation_breathingLevelQuestion => '從一樓依自身正常速度爬到五樓的喘度？';

  @override
  String get estimation_breathingLevel1 => '1 - 沒感覺';

  @override
  String get estimation_breathingLevel3 => '3 - 會累但不喘';

  @override
  String get estimation_breathingLevel5 => '5 - 很喘';

  @override
  String get estimation_inactivityLabel => '不活動月數 (例如：3)';

  @override
  String get estimation_monthsUnit => '個月';

  @override
  String get estimation_calculateButton => '計算並儲存我的腳程係數';

  @override
  String get estimation_resultTitle => '您的腳程係數約為';

  @override
  String get estimation_resultDescription =>
      '(此為相對於上河時間的倍率。例如 1.0 代表與上河時間相同，0.8 代表您走得比上河時間快，1.2 代表您走得比上河時間慢。)';

  @override
  String get estimation_resultWarning =>
      '提醒：如果一個月內未運動或登山，建議估算時間再加乘 1.1。三個月沒運動則乘以 1.1 的三次方。';

  @override
  String get merge_selectButton => '選擇 GPX 檔案 (最多3個)';

  @override
  String get merge_mergeButton => '合併 GPX 檔案';

  @override
  String get merge_selectedFilesTitle => '已選檔案:';

  @override
  String get merge_noFilesSelected => '尚未選擇任何檔案。';

  @override
  String get merge_successDialogTitle => '合併成功';

  @override
  String get merge_successDialogContent =>
      '合併後的 GPX 檔案已儲存至您的地圖庫.\n\n您是否要前往「GPX 地圖規劃」頁面進一步編輯？';

  @override
  String get merge_stayHereButton => '留在本頁';

  @override
  String get merge_goToPlanningButton => '前往規劃';

  @override
  String get merge_errorTooManyFiles => '最多只能選擇 3 個檔案。';

  @override
  String get merge_errorTooFewFiles => '請至少選擇 2 個檔案進行合併。';

  @override
  String merge_errorFileTooLarge(String fileName) {
    return '檔案 \"$fileName\" 過大，超過 1000KB 的限制。';
  }

  @override
  String merge_errorNotGpx(String fileName) {
    return '檔案 \"$fileName\" 不是 GPX 檔案。';
  }

  @override
  String merge_errorGeneric(String error) {
    return '發生錯誤: $error';
  }

  @override
  String get loading => '載入中...';

  @override
  String get error => '發生錯誤';

  @override
  String get retry => '重試';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確認';

  @override
  String get save => '儲存';

  @override
  String get delete => '刪除';

  @override
  String get edit => '編輯';

  @override
  String get search => '搜尋';

  @override
  String get filter => '篩選';

  @override
  String get sort => '排序';

  @override
  String get share => '分享';

  @override
  String get export => '匯出';

  @override
  String get import => '匯入';

  @override
  String get upload => '上傳';

  @override
  String get download => '下載';

  @override
  String get settings => '設定';

  @override
  String get profile => '個人檔案';

  @override
  String get logout => '登出';

  @override
  String get login => '登入';

  @override
  String get register => '註冊';

  @override
  String get welcome => '歡迎';

  @override
  String get back => '返回';

  @override
  String get next => '下一步';

  @override
  String get previous => '上一步';

  @override
  String get done => '完成';

  @override
  String get close => '關閉';

  @override
  String get open => '開啟';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get ok => '確定';

  @override
  String get selectFile => '選擇檔案';

  @override
  String fileSelected(int count) {
    return '已選擇 $count 個檔案';
  }

  @override
  String get noFileSelected => '未選擇檔案';

  @override
  String get fileUploadSuccess => '檔案上傳成功';

  @override
  String get fileUploadError => '檔案上傳失敗';

  @override
  String fileSizeLimit(String size) {
    return '檔案大小限制：$size';
  }

  @override
  String get distance => '距離';

  @override
  String get elevation => '海拔';

  @override
  String get elevationGain => '累積爬升';

  @override
  String get elevationLoss => '累積下降';

  @override
  String get duration => '時間';

  @override
  String get speed => '速度';

  @override
  String get pace => '配速';

  @override
  String get difficulty => '難度';

  @override
  String get easy => '簡單';

  @override
  String get moderate => '中等';

  @override
  String get hard => '困難';

  @override
  String get expert => '專家';

  @override
  String get startPoint => '起點';

  @override
  String get endPoint => '終點';

  @override
  String get waypoint => '航點';

  @override
  String get currentLocation => '目前位置';

  @override
  String get destination => '目的地';

  @override
  String get route => '路線';

  @override
  String get track => '軌跡';

  @override
  String get map => '地圖';

  @override
  String get satellite => '衛星';

  @override
  String get terrain => '地形';

  @override
  String get hybrid => '混合';

  @override
  String get weather => '天氣';

  @override
  String get temperature => '溫度';

  @override
  String get humidity => '濕度';

  @override
  String get windSpeed => '風速';

  @override
  String get precipitation => '降雨機率';

  @override
  String get equipment => '裝備';

  @override
  String get required => '必備';

  @override
  String get optional => '選備';

  @override
  String get quantity => '數量';

  @override
  String get weight => '重量';

  @override
  String get totalWeight => '總重量';

  @override
  String get checklist => '檢查清單';

  @override
  String get completed => '已完成';

  @override
  String get incomplete => '未完成';

  @override
  String get mergeGpx => '合併 GPX';

  @override
  String get selectFilesToMerge => '選擇要合併的檔案';

  @override
  String get mergeSuccess => '合併成功';

  @override
  String get mergeError => '合併失敗';

  @override
  String get processing => '處理中...';

  @override
  String get aiSuggestion => 'AI 建議';

  @override
  String get optimizeRoute => '優化路線';

  @override
  String get shortestPath => '最短路徑';

  @override
  String get leastElevation => '最少爬升';

  @override
  String get safestRoute => '最安全路線';

  @override
  String get favorites => '我的最愛';

  @override
  String get addToFavorites => '加入最愛';

  @override
  String get removeFromFavorites => '移除最愛';

  @override
  String get favoritesLimit => '最愛的上限是4個，請對其中做出斷捨離';

  @override
  String get announcement => '官方公告';

  @override
  String get news => '最新消息';

  @override
  String get notification => '通知';

  @override
  String get message => '訊息';

  @override
  String get networkError => '網路連線錯誤';

  @override
  String get serverError => '伺服器錯誤';

  @override
  String get unknownError => '未知錯誤';

  @override
  String get tryAgainLater => '請稍後再試';

  @override
  String get privacyPolicy => '隱私政策';

  @override
  String get termsOfService => '服務條款';

  @override
  String get about => '關於';

  @override
  String get version => '版本';

  @override
  String get contactUs => '聯絡我們';

  @override
  String get feedback => '意見回饋';

  @override
  String get reportBug => '回報問題';

  @override
  String get lastUpdated => '最後更新';

  @override
  String get createdAt => '建立時間';

  @override
  String get modifiedAt => '修改時間';

  @override
  String get syncData => '同步資料';

  @override
  String get offlineMode => '離線模式';

  @override
  String get onlineMode => '線上模式';

  @override
  String get tutorial => '教學';

  @override
  String get help => '說明';

  @override
  String get faq => '常見問題';

  @override
  String get guide => '使用指南';

  @override
  String get tips => '小提示';

  @override
  String get shareWith => '分享給';

  @override
  String get copyLink => '複製連結';

  @override
  String get qrCode => 'QR Code';

  @override
  String get scanQrCode => '掃描 QR Code';

  @override
  String get year => '年';

  @override
  String get month => '月';

  @override
  String get day => '日';

  @override
  String get hour => '小時';

  @override
  String get minute => '分鐘';

  @override
  String get second => '秒';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get tomorrow => '明天';

  @override
  String get thisWeek => '本週';

  @override
  String get lastWeek => '上週';

  @override
  String get thisMonth => '本月';

  @override
  String get lastMonth => '上月';

  @override
  String get male => '男性';

  @override
  String get female => '女性';

  @override
  String get other => '其他';

  @override
  String get age => '年齡';

  @override
  String get height => '身高';

  @override
  String get weight_unit => '體重';

  @override
  String get experience => '經驗';

  @override
  String get beginner => '初學者';

  @override
  String get intermediate => '中級';

  @override
  String get advanced => '進階';

  @override
  String get professional => '專業';

  @override
  String get achievement => '成就';

  @override
  String get badge => '徽章';

  @override
  String get level => '等級';

  @override
  String get points => '點數';

  @override
  String get ranking => '排名';

  @override
  String get leaderboard => '排行榜';

  @override
  String get statistics => '統計';

  @override
  String get progress => '進度';

  @override
  String get connectionLost => '連線中斷';

  @override
  String get reconnecting => '重新連線中...';

  @override
  String get connected => '已連線';

  @override
  String get disconnected => '已斷線';
}
