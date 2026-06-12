import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing comes from `android/key.properties` (git-ignored; template:
// `android/key.properties.example`). Debug builds do not require it and are
// not blocked by a missing/incomplete release signing config. When it is
// missing or incomplete, release tasks fail with an actionable message
// instead of silently falling back to debug signing.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        FileInputStream(keystorePropertiesFile).use { load(it) }
    }
}

fun keystoreProperty(name: String): String? =
    keystoreProperties.getProperty(name)?.trim()?.takeIf { it.isNotEmpty() }

// `Project.file()` keeps absolute paths as-is and resolves relative paths
// against the `android/` directory (the root of this Gradle build).
val releaseStoreFile = keystoreProperty("storeFile")?.let { rootProject.file(it) }

val releaseSigningProblem: String? = run {
    val required = listOf("storePassword", "keyPassword", "keyAlias", "storeFile")
    val missing = required.filter { keystoreProperty(it) == null }
    when {
        !keystorePropertiesFile.exists() -> "android/key.properties not found."
        missing.isNotEmpty() ->
            "android/key.properties is missing value(s) for: ${missing.joinToString(", ")}."
        releaseStoreFile?.exists() != true ->
            "storeFile '$releaseStoreFile' does not exist."
        else -> null
    }
}

android {
    namespace = "com.rectify.rectify"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.rectify.rectify"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (releaseSigningProblem == null) {
            create("release") {
                storeFile = releaseStoreFile
                storePassword = keystoreProperty("storePassword")
                keyAlias = keystoreProperty("keyAlias")
                keyPassword = keystoreProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // Never fall back to debug signing. Without a complete
            // `android/key.properties` the release build type carries no
            // signing config, and the task-graph guard below fails any
            // requested release task with instructions.
            signingConfig = if (releaseSigningProblem == null) {
                signingConfigs.getByName("release")
            } else {
                null
            }
        }
    }
}

if (releaseSigningProblem != null) {
    gradle.taskGraph.whenReady {
        val releaseTaskRequested = allTasks.any { task ->
            task.project == project && task.name.contains("Release")
        }
        if (releaseTaskRequested) {
            throw GradleException(
                "Android release signing is not configured: $releaseSigningProblem\n" +
                    "Copy android/key.properties.example to android/key.properties and " +
                    "set storePassword, keyPassword, keyAlias, and storeFile to the " +
                    "owner-provided upload keystore.\n" +
                    "Debug builds do not require android/key.properties."
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
