plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.windsong.gpx_merger_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.windsong.gpx_merger_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    //憑證設定
        signingConfigs {
        create("release") {
            storeFile = file("gpx_merger_app.jks")
            storePassword = "REDACTED_KEYSTORE_PASSWORD"
            keyAlias = "windsong"
            keyPassword = "REDACTED_KEYSTORE_PASSWORD"
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            //isShrinkResources = false  // 如果有這行的話
                     proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"  // 加入這行
        )

            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            //test的版本
            //signingConfig = signingConfigs.getByName("debug")
            //正式的寫法要改
            signingConfig = signingConfigs.getByName("release")
        }
    }

    defaultConfig {
        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
        }
    }
}

flutter {
    source = "../.."
}
