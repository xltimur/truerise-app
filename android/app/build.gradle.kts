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
            task.project == project &&
                task.name.contains("Release") &&
                // The bundled-env validation task must stay runnable on its
                // own without signing secrets.
                task.name != "validateReleaseBundledEnv"
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

// --- Bundled .env review-key release guard --------------------------------
// The repo tracks `.env` as a Flutter asset so review/demo builds boot with
// a live provider key (README "Security boundary"). Assets are extractable
// from a public APK/AAB, so release builds must not silently ship that key:
// this task fails unless the owner explicitly acknowledges the bundled key
// as a low-budget, capped, rotatable review key. The key value itself is
// never read into any message. Mirrors `tool/release_env_guard.dart`, which
// is the manual preflight for iOS builds.
val validateReleaseBundledEnv = tasks.register("validateReleaseBundledEnv") {
    group = "verification"
    description =
        "Blocks release builds that bundle an unacknowledged ASTRO_API_KEY via the tracked .env."
    doLast {
        val envFile = rootProject.file("../.env")
        val keyPresent = envFile.exists() && envFile.readLines().any { rawLine ->
            val line = rawLine.trim()
            if (line.startsWith("#")) return@any false
            val match = Regex("^ASTRO_API_KEY\\s*=(.*)$").find(line) ?: return@any false
            var value = match.groupValues[1].trim()
            if (value.length >= 2 &&
                ((value.startsWith("\"") && value.endsWith("\"")) ||
                    (value.startsWith("'") && value.endsWith("'")))
            ) {
                value = value.substring(1, value.length - 1).trim()
            }
            value.isNotEmpty()
        }
        val allow = findProperty("truerise.allowBundledApiKey") == "true"
        val purpose = findProperty("truerise.bundledApiKeyPurpose")
        if (keyPresent && !(allow && purpose == "review-capped")) {
            throw GradleException(
                "Release blocked: the tracked .env bundles a non-empty ASTRO_API_KEY " +
                    "(value redacted) as a Flutter asset, which is extractable from a " +
                    "public APK/AAB. A public release must ship either no provider key " +
                    "or a low-budget, capped, rotatable review key acknowledged " +
                    "explicitly with:\n" +
                    "  -Ptruerise.allowBundledApiKey=true " +
                    "-Ptruerise.bundledApiKeyPurpose=review-capped\n" +
                    "Otherwise remove ASTRO_API_KEY from .env before building. " +
                    "See README \"Security boundary\" and docs/api-integration.md."
            )
        }
    }
}

// Gate only the release artifacts; debug/profile stay untouched.
// `preReleaseBuild` runs at the head of the release task chain so the
// guard fails fast instead of after a full compile.
tasks.configureEach {
    if (name == "assembleRelease" ||
        name == "bundleRelease" ||
        name == "preReleaseBuild"
    ) {
        dependsOn(validateReleaseBundledEnv)
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
