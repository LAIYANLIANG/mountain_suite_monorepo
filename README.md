# mountain_suite_monorepo

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Architecture](https://img.shields.io/badge/Architecture-Offline--First%20%7C%20BLoC-green)](#%EF%B8%8F-monorepo-%E5%B0%88%E6%A1%88%E7%B5%90%E6%A7%8B)

專為登山與戶外路線打造的 **Flutter / Dart Monorepo** 工具套件。只要使用 `.gpx` 軌跡檔案，都能透過本專案進行視覺化路線規劃、多檔整併、路程評估、裝備重量盤點、本機地圖庫管理與即時 GPS 軌跡記錄。

---

## 🎬 專案功能展示與實測短片

以下為本專案各核心功能的實際操作錄影與登山實測短片（YouTube Shorts）：

| 分類 | 影片主題 | 觀看連結 |
| --- | --- | --- |
| **總覽介紹** | 功能介紹 | [觀看短片](https://youtube.com/shorts/pkY9221m5kw?si=_-vdeTQPI1kBNWFV) |
| **GPX 處理與地圖** | GPX 匯入影片 | [觀看短片](https://youtube.com/shorts/NH0pvhBpMRY?si=8OK7HJjb2sXtZMUZ) |
| **GPX 處理與地圖** | GPX 路徑匯入地圖 | [觀看短片](https://youtube.com/shorts/Z8lTrlx53yo?si=vsq_8CSIRGZ0wKr6) |
| **GPX 處理與地圖** | GPX 合併影片 | [觀看短片](https://youtube.com/shorts/MgrkOnZhbRw?si=1JnTwURYBkT0uslo) |
| **GPX 處理與地圖** | GPX 地圖庫 | [觀看短片](https://youtube.com/shorts/uP-y4XU6tXo?si=mJxrB2YKCIVEXE7u) |
| **行程與裝備管理** | 路徑評估 | [觀看短片](https://youtube.com/shorts/lrpPSeyCz9A?si=bAH3Qn6g1o3iM5If) |
| **行程與裝備管理** | 裝備盤點與重量統計 | [觀看短片](https://youtube.com/shorts/Q1ciIvnC8k4?si=FpvovfdSfBysOtyh) |
| **山區實測紀錄** | 記錄行走路徑 | [觀看短片](https://youtube.com/shorts/7DTYPhmbVMA?si=hG7NoPREWZCAA-Gb) |
| **山區實測紀錄** | 嘉明湖的鹿（實地花絮） | [觀看短片](https://youtube.com/shorts/IhEmHHoeGq0?si=jB82a10aFEq3Y-XQ) |

---

## ✨ 核心功能總覽

- **Offline-First 離線優先設計**：核心功能不依賴網路連線，GPX 檔案與中繼資料透過本機檔案系統與 `sqflite` (SQLite) 儲存，適合山區無訊號環境使用（雲端同步、社群與登入功能由 `FeatureFlags` 控制，MVP 預設關閉）。
- **GPX 地圖規劃與編輯 (`gpx_planning_screen`)**：支援從裝置或本機地圖庫載入 GPX，在地圖上編輯軌跡點、管理與排序航點 (WPT)、規劃路線並匯出或存回地圖庫。
- **現有 GPX 整併 (`gpx_merge_screen` / `gpx_merger_app`)**：支援將多段 GPX 軌跡檔案合併為單一完整路線，並可直接開啟、分享或存入地圖庫。
- **路程評估 (`route_evaluation_screen` / `route_estimation_bloc`)**：依標準步程時間與個人體能／未活動係數評估行程所需時間。
- **裝備盤點與重量統計 (`equipment_checklist_screen`)**：分類管理個人、團體、基礎與技術裝備清單，即時統計總重量並本機儲存。
- **本機 GPX 地圖庫 (`gpx_library_screen`)**：集中匯入、搜尋、檢視與管理儲存在裝置本機的 GPX 軌跡檔案。
- **即時軌跡記錄 (`tracking_screen`)**：可匯入 GPX 參考路線並透過 GPS 持續記錄目前行走軌跡，支援開始、暫停、繼續、結束與命名存檔。
- **多國語系支援 (i18n)**：`mountain_hiking_app` 內建繁體中文 (`zh`)、英文 (`en`)、日文 (`ja`)、韓文 (`ko`)、印尼文 (`id`) 與越南文 (`vi`) 6 種語系。

---

## 🏗️ Monorepo 專案結構

```text
mountain_suite_monorepo/
├── apps/
│   ├── mountain_hiking_app/   # 主應用程式：整合地圖規劃、GPX 整併、路程評估、裝備盤點、地圖庫與軌跡記錄
│   └── gpx_merger_app/        # 獨立應用程式：輕量級 GPX 檔案合併工具
└── packages/
    ├── gpx_core/              # 核心共用套件：GPX 模型、XML 解析/寫入、GpxRepository 與 GpxBloc
    └── shared_ui/             # 共用 UI 套件模板（預留後續跨 App UI 元件抽取）
```

---

## 🛠️ 技術棧與語言分佈

### 主要技術架構
- **框架與語言**：Flutter 3.x / Dart 3.x
- **狀態管理**：BLoC (`flutter_bloc`, `bloc`, `equatable`) + `provider`
- **地圖與定位**：`google_maps_flutter`, `geolocator`, `permission_handler`
- **本機儲存與檔案**：`sqflite`, `shared_preferences`, `path_provider`, `file_picker`, `file_saver`, `xml`, `gpx`
- **環境設定與雲端預留**：`flutter_dotenv`（管理 API Key 等設定）；Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_app_check`, `google_sign_in`) 透過 `FeatureFlags` 預留擴充

### 程式碼語言組成
依據清理建置暫存與報告後之專案原始碼統計：
- **Dart**（主要應用與邏輯層）：約 86.0%（95 個檔案，15,122 行）
- **C / C++**（Windows / Linux 桌面端 Flutter Runner 樣板）：約 10.1%（32 個 `.cpp` / `.cc` / `.h` 檔案，1,775 行）
- **Kotlin / Gradle Kotlin DSL**（Android 進入點與建置腳本）：約 1.5%（9 個 `.kt` / `.kts` 檔案，271 行）
- **Swift**（iOS / macOS 進入點與環境載入）：約 1.3%（12 個檔案，222 行）
- **CMake / HTML**（桌面端建置設定與 Web 進入點）：約 1.1%（6 個檔案，197 行）
- 其他：ARB 多語系檔（6 種語言）、YAML、XML / Plist、Markdown 文件與規格書

---

## 🚀 快速開始與環境設定

本專案已將 API 金鑰、簽章密碼與平台組態從 Git 版控中分離。首次 Clone 後，請先從範例樣板建立本地設定檔：

### 1. 設定環境變數 (`.env`)
```bash
cp apps/mountain_hiking_app/.env.example apps/mountain_hiking_app/.env
```
編輯 `apps/mountain_hiking_app/.env`，填入您的 `GOOGLE_MAPS_API_KEY`（以及若啟用雲端模式時所需的 `GOOGLE_SERVER_CLIENT_ID` 與 `FIREBASE_*` 設定）。

### 2. 設定 Firebase 平台組態（若需建置 Android / iOS / macOS 含 Firebase 專案）
```bash
cp apps/mountain_hiking_app/android/app/google-services.json.example apps/mountain_hiking_app/android/app/google-services.json
cp apps/mountain_hiking_app/ios/Runner/GoogleService-Info.plist.example apps/mountain_hiking_app/ios/Runner/GoogleService-Info.plist
cp apps/mountain_hiking_app/macos/Runner/GoogleService-Info.plist.example apps/mountain_hiking_app/macos/Runner/GoogleService-Info.plist
```
> 若要建置 Web 版本並啟用 Google Maps，請於建置／部署時將 `apps/mountain_hiking_app/web/index.html` 中的 `YOUR_GOOGLE_MAPS_API_KEY` 替換為實際金鑰。

### 3. 設定 Android Release 簽章（選填，僅發行正式版需要）
```bash
cp apps/mountain_hiking_app/android/key.properties.example apps/mountain_hiking_app/android/key.properties
cp apps/gpx_merger_app/android/key.properties.example apps/gpx_merger_app/android/key.properties
```
在 `key.properties` 中填入實際的 `storePassword`、`keyPassword`、`keyAlias` 與 `storeFile` 路徑（`gpx_merger_app` 若未提供 `key.properties` 將自動退回 `debug` 簽章）。

### 4. 安裝依賴與執行測試
```bash
cd packages/gpx_core && flutter pub get && flutter test
cd ../../apps/mountain_hiking_app && flutter pub get && flutter test
```

---

## 📄 開源授權說明 (Open-Source License)

- **目前狀態**：本專案根目錄尚未建立 `LICENSE` 檔案；`apps/mountain_hiking_app` 與 `apps/gpx_merger_app` 皆設為 `publish_to: 'none'`（未發佈至 pub.dev），而 `packages/gpx_core/LICENSE` 與 `packages/shared_ui/LICENSE` 目前僅保留 Flutter 預設樣板內容（`TODO: Add your license here.`）。
- **建議**：若計劃正式開源釋出，建議於根目錄與子套件補上明確授權條款（如 **MIT**、**BSD-3-Clause** 或 **Apache-2.0**），以與 Flutter / Dart 生態系主流寬鬆授權保持相容。
- **第三方套件授權**：專案採用的主要 Flutter / Firebase / Google Maps / BLoC 生態套件多為 BSD-3-Clause、MIT 或 Apache-2.0 等寬鬆開源授權。
