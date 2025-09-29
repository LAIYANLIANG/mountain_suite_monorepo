
/// [MVP Refactor] 功能開關設定檔
///
/// 這個檔案提供一個中央控制點，用來啟用或停用 App 的主要功能模組，
/// 特別是用於切換「線上雲端模式」與「本地離線模式」。
/// - isCloudSyncEnabled: 控制是否與 Firebase 後端同步 (例如：Firebase 初始化)。
/// - isSocialFeatureEnabled: 控制社群功能是否可見與可用。
/// - isLoginEnabled: 控制是否啟用使用者登入/註torch 功能。
class FeatureFlags {
  static const bool isCloudSyncEnabled = false;
  static const bool isSocialFeatureEnabled = false;
  static const bool isLoginEnabled = false;
}
