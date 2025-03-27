plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.weatherapps"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.weatherapps"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            def keystoreProperties = new Properties()
            def keystoreFile = rootProject.file("key.properties")
            if (keystoreFile.exists()) {
                keystoreProperties.load(new FileInputStream(keystoreFile))
            }

            android {
                ...
                signingConfigs {
                    release {
                        storeFile file(keystoreProperties['storeFile'])
                        storePassword keystoreProperties['storePassword']
                        keyAlias keystoreProperties['keyAlias']
                        keyPassword keystoreProperties['keyPassword']
                    }
                }
                buildTypes {
                    release {
                        signingConfig signingConfigs.release
                                minifyEnabled false
                        shrinkResources false
                    }
                }
            }

        }
    }
}

flutter {
    source = "../.."
}
