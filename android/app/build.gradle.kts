import java.io.FileInputStream
import java.net.URI
import java.net.URISyntaxException
import java.util.Base64
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
        // First-publish bundle id is owner-gated: keep `com.rectify.rectify`
        // until the owner explicitly approves a change. Recommended candidate
        // is `app.astrolium.truerise` (see docs/bundle-id-recommendation.md).
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

// --- Bundled .env, share URL, and proxy URL release guard ------------------
// The repo tracks `.env` as a Flutter asset so review/demo builds boot with
// a live provider key (README "Security boundary"). Assets are extractable
// from a public APK/AAB, so release builds must not silently ship that key:
// this task fails unless the owner explicitly acknowledges the bundled key
// as a low-budget, capped, rotatable review key. The key value itself is
// never read into any message. The task also gates the release share/invite
// URL: the default placeholder needs explicit owner confirmation, and a
// custom TRUERISE_SHARE_URL must be bare HTTPS (host only, no userinfo, no
// query, no fragment) so shipped share copy cannot leak tracking/personal
// identifiers. The task also gates RECTIFY_PROXY_BASE_URL: the default
// placeholder blocks the release - a public build must route through a real
// owner-controlled proxy - unless explicitly acknowledged for local/test-only
// builds, and a custom proxy URL must be a host-only HTTPS origin (no path
// beyond an optional trailing "/", since RECTIFY_PROXY_PATH carries the
// endpoint path separately) so it cannot smuggle credentials or tracking
// identifiers into the shipped config.
// Rejected custom URLs are never echoed. Mirrors
// `tool/release_env_guard.dart`, which is the manual preflight for iOS
// builds.

// Default share/invite URL placeholder, mirrored from the Dart guard.
val defaultShareUrl = "https://truerise.app"

// Default RECTIFY_PROXY_BASE_URL placeholder, mirrored from the Dart guard.
val defaultProxyBaseUrl = "https://proxy.invalid.example"

// Flutter forwards --dart-define values to Gradle as the `dart-defines`
// project property: comma-separated entries, each a base64/base64url encoded
// `KEY=VALUE` pair. Decode defensively and skip undecodable entries.
fun decodeDartDefine(encoded: String): String? {
    val bytes = try {
        Base64.getUrlDecoder().decode(encoded)
    } catch (_: IllegalArgumentException) {
        try {
            Base64.getDecoder().decode(encoded)
        } catch (_: IllegalArgumentException) {
            return null
        }
    }
    return String(bytes, Charsets.UTF_8)
}

fun dartDefineValue(dartDefines: String, key: String): String? {
    for (entry in dartDefines.split(",")) {
        val decoded = decodeDartDefine(entry.trim()) ?: continue
        val separator = decoded.indexOf('=')
        if (separator <= 0) continue
        if (decoded.substring(0, separator) == key) {
            return decoded.substring(separator + 1)
        }
    }
    return null
}

// A custom share URL passes only as bare HTTPS: https scheme, host present,
// no userinfo, no query, no fragment. A path is allowed for share URLs.
fun isBareHttpsUrl(value: String): Boolean = try {
    val uri = URI(value)
    uri.scheme == "https" &&
        !uri.host.isNullOrEmpty() &&
        uri.rawUserInfo == null &&
        uri.rawQuery == null &&
        uri.rawFragment == null
} catch (_: URISyntaxException) {
    false
}

// A custom proxy base URL must additionally be a host-only HTTPS origin:
// no path beyond an optional trailing "/", because RECTIFY_PROXY_PATH
// carries the endpoint path separately.
fun isBareHttpsOriginUrl(value: String): Boolean = try {
    val uri = URI(value)
    isBareHttpsUrl(value) &&
        (uri.rawPath.isNullOrEmpty() || uri.rawPath == "/")
} catch (_: URISyntaxException) {
    false
}

val validateReleaseBundledEnv = tasks.register("validateReleaseBundledEnv") {
    group = "verification"
    description =
        "Blocks release builds whose bundled env carries an unacknowledged " +
            "ASTRO_API_KEY or whose share URL or proxy base URL release " +
            "config is unvetted."
    doLast {
        // Share URL gate: prefer the Flutter dart-define, then the direct
        // Gradle property, then the default placeholder.
        val dartDefines = findProperty("dart-defines") as? String
        val shareUrl = dartDefines?.let { dartDefineValue(it, "TRUERISE_SHARE_URL") }
            ?: (findProperty("truerise.shareUrl") as? String)
            ?: defaultShareUrl
        if (shareUrl == defaultShareUrl) {
            val allowDefault =
                findProperty("truerise.allowDefaultShareUrl") == "true"
            val sharePurpose = findProperty("truerise.shareUrlPurpose")
            if (!(allowDefault && sharePurpose == "owner-confirmed")) {
                throw GradleException(
                    "Release blocked: the release would ship the default " +
                        "placeholder share URL $defaultShareUrl. Pass the real " +
                        "owner-controlled URL via " +
                        "--dart-define=TRUERISE_SHARE_URL=<https-url> (or " +
                        "-Ptruerise.shareUrl=<https-url> for direct Gradle " +
                        "verification), or - ONLY if the owner confirms " +
                        "shipping the placeholder - acknowledge it explicitly " +
                        "with:\n" +
                        "  -Ptruerise.allowDefaultShareUrl=true " +
                        "-Ptruerise.shareUrlPurpose=owner-confirmed\n" +
                        "No other purpose is accepted."
                )
            }
        } else if (!isBareHttpsUrl(shareUrl)) {
            throw GradleException(
                "Release blocked: the custom TRUERISE_SHARE_URL value " +
                    "(redacted) is not a bare HTTPS URL. It must use " +
                    "https://, name a host, and carry no userinfo, no query, " +
                    "and no fragment, so the shipped share copy cannot leak " +
                    "tracking/personal identifiers."
            )
        }
        // Proxy base URL gate: prefer the Flutter dart-define, then the
        // direct Gradle property, then the default placeholder. The
        // placeholder blocks the release - a public build must route through
        // a real owner-controlled proxy - unless explicitly acknowledged for
        // a local/test build that never reaches users.
        val proxyBaseUrl = dartDefines
            ?.let { dartDefineValue(it, "RECTIFY_PROXY_BASE_URL") }
            ?: (findProperty("truerise.proxyBaseUrl") as? String)
            ?: defaultProxyBaseUrl
        if (proxyBaseUrl == defaultProxyBaseUrl) {
            val allowDefaultProxy =
                findProperty("truerise.allowDefaultProxyUrl") == "true"
            val proxyPurpose = findProperty("truerise.proxyUrlPurpose")
            if (!(allowDefaultProxy && proxyPurpose == "local-test-only")) {
                throw GradleException(
                    "Release blocked: the release would ship the default " +
                        "placeholder RECTIFY_PROXY_BASE_URL " +
                        "$defaultProxyBaseUrl. Pass the real owner-controlled " +
                        "proxy URL via " +
                        "--dart-define=RECTIFY_PROXY_BASE_URL=<https-url> (or " +
                        "-Ptruerise.proxyBaseUrl=<https-url> for direct " +
                        "Gradle verification), or - ONLY for a local/test " +
                        "build that never reaches users - acknowledge the " +
                        "placeholder explicitly with:\n" +
                        "  -Ptruerise.allowDefaultProxyUrl=true " +
                        "-Ptruerise.proxyUrlPurpose=local-test-only\n" +
                        "No other purpose is accepted."
                )
            }
        } else if (!isBareHttpsOriginUrl(proxyBaseUrl)) {
            throw GradleException(
                "Release blocked: the custom RECTIFY_PROXY_BASE_URL value " +
                    "(redacted) is not a host-only HTTPS origin. It must use " +
                    "https://, name a host, and carry no path (a single " +
                    "trailing \"/\" is allowed), no userinfo, no query, and " +
                    "no fragment - RECTIFY_PROXY_PATH carries the endpoint " +
                    "path separately - so the shipped config cannot leak " +
                    "credentials or tracking identifiers."
            )
        }
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
