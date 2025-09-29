// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '登山アプリ';

  @override
  String get homeScreenTitle => 'ホーム';

  @override
  String get infoScreenTitle => '参考情報';

  @override
  String get gpxPlanningScreenTitle => 'GPXルート計画';

  @override
  String get gpxMergeScreenTitle => 'GPX結合';

  @override
  String get routeEstimationScreenTitle => '行動時間評価';

  @override
  String get equipmentChecklistScreenTitle => '装備チェックリスト';

  @override
  String get gpxLibraryScreenTitle => 'GPXライブラリ';

  @override
  String get authScreenTitle => 'アカウント管理';

  @override
  String get socialFeedTitle => 'コミュニティ';

  @override
  String get trackingFeatureTitle => '軌跡の記録';

  @override
  String get trackingStoppedMessage => '記録を停止しました。';

  @override
  String get startTrackingButton => '記録開始';

  @override
  String get pauseTrackingButton => '一時停止';

  @override
  String get stopTrackingButton => '停止';

  @override
  String get resumeTrackingButton => '再開';

  @override
  String get defaultTrackName => '私の軌跡';

  @override
  String get trackNameLabel => '軌跡の名前';

  @override
  String get saveTrackButton => '軌跡を保存';

  @override
  String get startNewTrackButton => '新しい軌跡を開始';

  @override
  String get home_startPlanning => '新しいルートの計画を始める';

  @override
  String get checklist_personalGear => '個人装備';

  @override
  String get checklist_groupGear => '共同装備';

  @override
  String get checklist_baseGear => '基本装備';

  @override
  String get checklist_technicalGear => '技術装備・雪山装備';

  @override
  String get checklist_otherGear => 'その他の装備';

  @override
  String get checklist_totalWeight => '総重量';

  @override
  String get checklist_quantity => '数量';

  @override
  String get checklist_weightGrams => '重量(g)';

  @override
  String get checklist_snowEssential => '雪山シーズン必須';

  @override
  String get estimation_routeQixing => '小油坑から七星山主峰往復';

  @override
  String get estimation_routeTianmu => '天母古道';

  @override
  String get estimation_routeYushan => '玉山主峰';

  @override
  String get estimation_routeHehuan => '合歓山北峰';

  @override
  String get estimation_yourTimeHint => 'あなたの所要時間';

  @override
  String get estimation_minutesUnit => '分';

  @override
  String get estimation_breathingLevelQuestion =>
      'ご自身のペースで1階から5階まで登った際の息の上がり具合は？';

  @override
  String get estimation_breathingLevel1 => '1 - 全く息が上がらない';

  @override
  String get estimation_breathingLevel3 => '3 - 疲れるが息は上がらない';

  @override
  String get estimation_breathingLevel5 => '5 - 非常に息が上がる';

  @override
  String get estimation_inactivityLabel => '運動していない月数（例：3）';

  @override
  String get estimation_monthsUnit => 'ヶ月';

  @override
  String get estimation_calculateButton => '私のペース係数を計算して保存';

  @override
  String get estimation_resultTitle => 'あなたのペース係数は約';

  @override
  String get estimation_resultDescription =>
      '（これは標準コースタイムに対する倍率です。例：1.0は標準、0.8は速い、1.2は遅い）';

  @override
  String get estimation_resultWarning =>
      '注意：1ヶ月以上運動や登山をしていない場合、推定時間に1.1を掛けることをお勧めします。3ヶ月間運動していない場合は、1.1を3回掛け合わせます。';

  @override
  String get merge_selectButton => 'GPXファイルを選択 (最大3件)';

  @override
  String get merge_mergeButton => 'GPXファイルを結合';

  @override
  String get merge_selectedFilesTitle => '選択中のファイル:';

  @override
  String get merge_noFilesSelected => 'ファイルが選択されていません。';

  @override
  String get merge_successDialogTitle => '結合に成功しました';

  @override
  String get merge_successDialogContent =>
      '結合されたGPXファイルはライブラリに保存されました。\n\n続けてルート計画ページで編集しますか？';

  @override
  String get merge_stayHereButton => 'このまま留まる';

  @override
  String get merge_goToPlanningButton => '計画ページへ進む';

  @override
  String get merge_errorTooManyFiles => '最大3つのファイルまで選択可能です。';

  @override
  String get merge_errorTooFewFiles => '結合するには、2つ以上のファイルを選択してください。';

  @override
  String merge_errorFileTooLarge(String fileName) {
    return 'ファイル「$fileName」はサイズが大きすぎます (上限1000KB)。';
  }

  @override
  String merge_errorNotGpx(String fileName) {
    return 'ファイル「$fileName」はGPXファイルではありません。';
  }

  @override
  String merge_errorGeneric(String error) {
    return 'エラーが発生しました: $error';
  }

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラーが発生しました';

  @override
  String get retry => '再試行';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get search => '検索';

  @override
  String get filter => 'フィルター';

  @override
  String get sort => '並べ替え';

  @override
  String get share => '共有';

  @override
  String get export => 'エクスポート';

  @override
  String get import => 'インポート';

  @override
  String get upload => 'アップロード';

  @override
  String get download => 'ダウンロード';

  @override
  String get settings => '設定';

  @override
  String get profile => 'プロフィール';

  @override
  String get logout => 'ログアウト';

  @override
  String get login => 'ログイン';

  @override
  String get register => '新規登録';

  @override
  String get welcome => 'ようこそ';

  @override
  String get back => '戻る';

  @override
  String get next => '次へ';

  @override
  String get previous => '前へ';

  @override
  String get done => '完了';

  @override
  String get close => '閉じる';

  @override
  String get open => '開く';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get ok => 'OK';

  @override
  String get selectFile => 'ファイルを選択';

  @override
  String fileSelected(int count) {
    return '$count個のファイルを選択中';
  }

  @override
  String get noFileSelected => 'ファイルが選択されていません';

  @override
  String get fileUploadSuccess => 'ファイルのアップロードに成功しました';

  @override
  String get fileUploadError => 'ファイルのアップロードに失敗しました';

  @override
  String fileSizeLimit(String size) {
    return 'ファイルサイズ制限: $size';
  }

  @override
  String get distance => '距離';

  @override
  String get elevation => '標高';

  @override
  String get elevationGain => '累積標高（登り）';

  @override
  String get elevationLoss => '累積標高（下り）';

  @override
  String get duration => '所要時間';

  @override
  String get speed => '速度';

  @override
  String get pace => 'ペース';

  @override
  String get difficulty => '難易度';

  @override
  String get easy => '初級';

  @override
  String get moderate => '中級';

  @override
  String get hard => '上級';

  @override
  String get expert => 'エキスパート';

  @override
  String get startPoint => '出発点';

  @override
  String get endPoint => '到着点';

  @override
  String get waypoint => 'ウェイポイント';

  @override
  String get currentLocation => '現在地';

  @override
  String get destination => '目的地';

  @override
  String get route => 'ルート';

  @override
  String get track => '軌跡';

  @override
  String get map => '地図';

  @override
  String get satellite => '衛星写真';

  @override
  String get terrain => '地形';

  @override
  String get hybrid => 'ハイブリッド';

  @override
  String get weather => '天気';

  @override
  String get temperature => '気温';

  @override
  String get humidity => '湿度';

  @override
  String get windSpeed => '風速';

  @override
  String get precipitation => '降水確率';

  @override
  String get equipment => '装備';

  @override
  String get required => '必須';

  @override
  String get optional => '任意';

  @override
  String get quantity => '数量';

  @override
  String get weight => '重量';

  @override
  String get totalWeight => '総重量';

  @override
  String get checklist => 'チェックリスト';

  @override
  String get completed => '完了';

  @override
  String get incomplete => '未完了';

  @override
  String get mergeGpx => 'GPXを結合';

  @override
  String get selectFilesToMerge => '結合するファイルを選択';

  @override
  String get mergeSuccess => '結合に成功しました';

  @override
  String get mergeError => '結合に失敗しました';

  @override
  String get processing => '処理中...';

  @override
  String get aiSuggestion => 'AI提案';

  @override
  String get optimizeRoute => 'ルートを最適化';

  @override
  String get shortestPath => '最短距離';

  @override
  String get leastElevation => '最小標高差';

  @override
  String get safestRoute => '最も安全なルート';

  @override
  String get favorites => 'お気に入り';

  @override
  String get addToFavorites => 'お気に入りに追加';

  @override
  String get removeFromFavorites => 'お気に入りから削除';

  @override
  String get favoritesLimit => 'お気に入りは4つまでです。追加するにはいずれかを削除してください。';

  @override
  String get announcement => '公式お知らせ';

  @override
  String get news => 'ニュース';

  @override
  String get notification => '通知';

  @override
  String get message => 'メッセージ';

  @override
  String get networkError => 'ネットワーク接続エラー';

  @override
  String get serverError => 'サーバーエラー';

  @override
  String get unknownError => '不明なエラーが発生しました';

  @override
  String get tryAgainLater => 'しばらくしてからもう一度お試しください';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String get about => 'このアプリについて';

  @override
  String get version => 'バージョン';

  @override
  String get contactUs => 'お問い合わせ';

  @override
  String get feedback => 'フィードバック';

  @override
  String get reportBug => '不具合を報告';

  @override
  String get lastUpdated => '最終更新';

  @override
  String get createdAt => '作成日時';

  @override
  String get modifiedAt => '変更日時';

  @override
  String get syncData => 'データを同期';

  @override
  String get offlineMode => 'オフラインモード';

  @override
  String get onlineMode => 'オンラインモード';

  @override
  String get tutorial => 'チュートリアル';

  @override
  String get help => 'ヘルプ';

  @override
  String get faq => 'よくある質問';

  @override
  String get guide => '利用ガイド';

  @override
  String get tips => 'ヒント';

  @override
  String get shareWith => '共有';

  @override
  String get copyLink => 'リンクをコピー';

  @override
  String get qrCode => 'QRコード';

  @override
  String get scanQrCode => 'QRコードをスキャン';

  @override
  String get year => '年';

  @override
  String get month => '月';

  @override
  String get day => '日';

  @override
  String get hour => '時間';

  @override
  String get minute => '分';

  @override
  String get second => '秒';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get tomorrow => '明日';

  @override
  String get thisWeek => '今週';

  @override
  String get lastWeek => '先週';

  @override
  String get thisMonth => '今月';

  @override
  String get lastMonth => '先月';

  @override
  String get male => '男性';

  @override
  String get female => '女性';

  @override
  String get other => 'その他';

  @override
  String get age => '年齢';

  @override
  String get height => '身長';

  @override
  String get weight_unit => '体重';

  @override
  String get experience => '経験';

  @override
  String get beginner => '初心者';

  @override
  String get intermediate => '中級者';

  @override
  String get advanced => '上級者';

  @override
  String get professional => 'プロ';

  @override
  String get achievement => '実績';

  @override
  String get badge => 'バッジ';

  @override
  String get level => 'レベル';

  @override
  String get points => 'ポイント';

  @override
  String get ranking => 'ランキング';

  @override
  String get leaderboard => '順位表';

  @override
  String get statistics => '統計';

  @override
  String get progress => '進捗';

  @override
  String get connectionLost => '接続が失われました';

  @override
  String get reconnecting => '再接続中...';

  @override
  String get connected => '接続済み';

  @override
  String get disconnected => '切断されました';
}
