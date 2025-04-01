import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.developers.weathersapp"  // ✅ FIXED: Correct namespace declaration
    compileSdk = 34  // ✅ FIXED: Use explicit SDK version

    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.developers.weathersapp"
        minSdk = 21  // ✅ FIXED: Explicit minSdk version
        targetSdk = 34  // ✅ FIXED: Explicit targetSdk version
        versionCode = 1
        versionName = "1.0"
    }

    // Load keystore properties for signing
    val keystorePropertiesFile = rootProject.file("key.properties")
    val keystoreProperties = Properties()

    try {
        if (keystorePropertiesFile.exists()) {
            keystoreProperties.load(FileInputStream(keystorePropertiesFile))
        }
    } catch (e: Exception) {
        throw GradleException("Error loading keystore properties: ${e.message}")
    }

    signingConfigs {
        create("release").apply {
            storeFile = file(keystoreProperties["storeFile"]?.toString() ?: throw GradleException("Keystore file not specified"))
            storePassword = keystoreProperties["storePassword"]?.toString() ?: throw GradleException("Keystore password not specified")
            keyAlias = keystoreProperties["keyAlias"]?.toString() ?: throw GradleException("Key alias not specified")
            keyPassword = keystoreProperties["keyPassword"]?.toString() ?: throw GradleException("Key password not specified")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
