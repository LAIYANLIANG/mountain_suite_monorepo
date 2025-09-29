import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import 'package:mountain_hiking_app/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:mountain_hiking_app/src/config/feature_flags.dart';

import 'package:mountain_hiking_app/src/business_logic/auth/auth_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/checklist/checklist_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_library/gpx_library_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/gpx_planning/gpx_planning_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/social/social_bloc.dart';
import 'package:mountain_hiking_app/src/business_logic/tracking/tracking_bloc.dart';

import 'package:mountain_hiking_app/src/data/providers/firebase_gpx_provider.dart';
import 'package:mountain_hiking_app/src/data/providers/local_gpx_provider.dart';

import 'package:mountain_hiking_app/src/data/repositories/auth/auth_repository.dart';
import 'package:mountain_hiking_app/src/data/repositories/auth/local_auth_repository.dart';
import 'package:mountain_hiking_app/src/data/repositories/equipment_repository.dart';
import 'package:mountain_hiking_app/src/data/repositories/gpx_library_repository.dart';

import 'package:mountain_hiking_app/src/data/services/auth/auth_api_service.dart';
import 'package:mountain_hiking_app/src/data/services/social_api_service.dart';

import 'package:mountain_hiking_app/src/presentation/screens/home_screen.dart';
import 'package:mountain_hiking_app/src/providers/locale_provider.dart';
import 'package:mountain_hiking_app/src/widgets/language_selection_dialog.dart';

import 'firebase_options.dart';

// [FIX] 移除 navigatorKey，因為權限請求邏輯已調整，不再需要 GlobalKey。

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (FeatureFlags.isCloudSyncEnabled) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: const AppProvider(),
    ),
  );
}

class AppProvider extends StatelessWidget {
  const AppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => FeatureFlags.isLoginEnabled
              ? AuthApiService()
              : LocalAuthRepository() as AuthRepository,
        ),
        RepositoryProvider<EquipmentRepository>(
          create: (context) => EquipmentRepository(),
        ),
        RepositoryProvider<GpxLibraryRepository>(
          create: (context) => GpxLibraryRepository(
            provider: FeatureFlags.isCloudSyncEnabled
                ? FirebaseGpxProvider()
                : LocalGpxProvider(),
          ),
        ),
        if (FeatureFlags.isSocialFeatureEnabled)
          RepositoryProvider<SocialApiService>(
            create: (context) => SocialApiService(),
          ),
      ],
      child: MultiBlocProvider(
        providers: [
          // INFO: App-level BLoCs that can be accessed from anywhere.
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(context.read<AuthRepository>())..add(AuthCheckRequested()),
          ),
          BlocProvider<GpxLibraryBloc>(
            create: (context) => GpxLibraryBloc(),
          ),
          BlocProvider<ChecklistBloc>(
            create: (context) => ChecklistBloc(context.read<EquipmentRepository>()),
          ),
          // INFO: SocialBloc depends on AuthBloc.
          if (FeatureFlags.isSocialFeatureEnabled)
            BlocProvider<SocialBloc>(
              create: (context) => SocialBloc(
                socialApiService: context.read<SocialApiService>(),
                authBloc: context.read<AuthBloc>(),
              ),
            ),
        ],
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      // [FIX] 移除 navigatorKey，因為權限請求邏輯已調整，不再需要 GlobalKey。
      locale: localeProvider.locale,
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)?.appTitle ?? 'Hiking App';
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppStartPage(),
    );
  }
}

/// 處理應用程式啟動時的初始邏輯，例如語言選擇和權限請求。
class AppStartPage extends StatefulWidget {
  const AppStartPage({super.key});

  @override
  State<AppStartPage> createState() => _AppStartPageState();
}

class _AppStartPageState extends State<AppStartPage> {
  // Gemini: 用於記錄是否已請求過權限的本地儲存 Key
  static const String _permissionsRequestedKey = 'permissions_requested';

  @override
  void initState() {
    super.initState();
    // Gemini: 將首次啟動的檢查（語言、權限）整合在一起，並在 frame 繪製完成後執行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunchAndRequestPermissions();
    });
  }

  /// 整合性的首次啟動檢查，包含語言和權限。
  Future<void> _checkFirstLaunchAndRequestPermissions() async {
    // 確保 Widget 已掛載到樹上
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();

    // 1. 檢查並設定語言
    final isLanguageSet = prefs.containsKey(LocaleProvider.languageCodeKey);
    if (!isLanguageSet && mounted) {
      // 使用 await 確保語言對話框關閉後再繼續，避免多個對話框重疊
      await showLanguageSelectionDialog(context);
    }

    // 2. 檢查並請求權限 (僅在首次啟動時)
    final havePermissionsBeenRequested = prefs.getBool(_permissionsRequestedKey) ?? false;
    if (!havePermissionsBeenRequested) {
      if (mounted) {
        // 呼叫權限請求函式
        await _requestPermissions(context);
      }
      // 無論使用者同意或拒絕，都將旗標設為 true，確保之後不再主動詢問
      await prefs.setBool(_permissionsRequestedKey, true);
    }
  }

  /// 請求應用程式所需權限的函式。
  ///
  /// [FIX] 調整權限請求邏輯，僅在權限尚未被授予時才發出請求。
  /// 如果權限已被永久拒絕，會顯示一個對話框引導用戶到設定頁面。
  Future<void> _requestPermissions(BuildContext context) async { // 接收 context
    // 定義需要請求的權限列表
    final List<Permission> permissionsToRequest = [
      Permission.locationAlways, // 為了背景軌跡記錄
      Permission.storage, // 為了讀寫 GPX 檔案
    ];

    Map<Permission, PermissionStatus> statuses = await permissionsToRequest.request();

    // 遍歷權限並檢查其狀態
    for (var permission in permissionsToRequest) {
      final status = await permission.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        // 如果權限被拒絕或永久拒絕，顯示提示對話框
        if (!mounted) continue; // 檢查 context 是否仍然有效
        await _showPermissionDeniedDialog(
          context,
          '${permission.toString().split('.').last} 權限被拒絕',
          '為了讓應用程式正常運作，需要您的 ${permission.toString().split('.').last} 權限。請在設定中開啟。'
        );
      }
    }
  }

  /// 顯示權限被拒絕時的提示對話框。
  ///
  /// 引導用戶到應用程式設定頁面手動開啟權限。
  Future<void> _showPermissionDeniedDialog(BuildContext context, String title, String content) async { // 接收 context
    await showDialog(
      context: context, // 使用傳入的 context
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('前往設定'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                openAppSettings(); // 開啟應用程式設定頁面
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
