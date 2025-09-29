# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.** { *; }

# 您的應用
-keep class com.windsong.gpx_merger_app.** { *; }

# 忽略 Google Play Core（如果不使用動態功能）
-dontwarn com.google.android.play.core.**
-ignorewarnings

# 保留註解
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions

# 針對您使用的插件
-keep class com.mr.flutter.plugin.filepicker.** { *; }
-keep class com.baseflow.permissionhandler.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }
-keep class dev.fluttercommunity.plus.share.** { *; }

# XML
-keep class org.xmlpull.** { *; }
-dontwarn org.xmlpull.**

# 保留原生方法
-keepclasseswithmembernames class * {
    native <methods>;
}

# 保留 Parcelable
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# 忽略 Google Play Core 相關的警告（您沒有使用動態功能模塊）
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task