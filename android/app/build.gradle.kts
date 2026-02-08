import com.android.build.gradle.internal.api.BaseVariantOutputImpl
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// Load optional signing properties from local.properties (kept out of VCS)
val versionPropsFile = rootProject.file("local.properties")
val localProps = Properties()
if (versionPropsFile.exists()) {
    versionPropsFile.inputStream().use { localProps.load(it) }
}

val releaseStoreFile = localProps.getProperty("release.storeFile")
val releaseStorePassword = localProps.getProperty("release.storePassword")
val releaseKeyAlias = localProps.getProperty("release.keyAlias")
val releaseKeyPassword = localProps.getProperty("release.keyPassword")

val currentVersionCode = (localProps.getProperty("VERSION_CODE") ?: "1").toInt()
val currentVersionName = localProps.getProperty("VERSION_NAME") ?: "1.0.0"

// Version bumping task for release builds
tasks.register("bumpVersion") {
    doLast {
        val newVersionCode = currentVersionCode + 1

        val parts = currentVersionName.split(".")
        var major = parts[0].toInt()
        var minor = parts[1].toInt()
        var patch = parts[2].toInt()

        patch++
        if (patch >= 100) {
            patch = 0
            minor++
        }
        if (minor >= 100) {
            minor = 0
            major++
        }

        val newVersionName = "$major.$minor.$patch"

        println(">>> Bumped versionName: $currentVersionName → $newVersionName")
        println(">>> Bumped versionCode: $currentVersionCode → $newVersionCode")

        localProps["VERSION_CODE"] = newVersionCode.toString()
        localProps["VERSION_NAME"] = newVersionName
        versionPropsFile.outputStream().use { localProps.store(it, null) }
    }
}

// Make release builds depend on version bump
tasks.matching { it.name == "assembleRelease" || it.name == "bundleRelease" }.configureEach {
    dependsOn("bumpVersion")
}

// Rename AAB outputs after bundleRelease completes
tasks.whenTaskAdded {
    if (name == "bundleRelease") {
        doLast {
            val date = SimpleDateFormat("yyMMdd.HHmm").format(Date())
            val bundleDir = layout.buildDirectory.dir("outputs/bundle/release").get().asFile
            bundleDir.listFiles()?.filter { it.extension == "aab" }?.forEach { aabFile ->
                val newName = "portfolio-$date-v$currentVersionName+$currentVersionCode-release.aab"
                val newFile = File(aabFile.parentFile, newName)
                if (aabFile.renameTo(newFile)) {
                    println(">>> Renamed AAB: ${aabFile.name} → $newName")
                } else {
                    println(">>> Failed to rename AAB: ${aabFile.name}")
                }
            }
        }
    }
}

android {
    namespace = "com.ymrabtiapps.thumbnails.thumbnail_youtube"
    compileSdk = 36

    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.ymrabtiapps.thumbnails.thumbnail_youtube"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = currentVersionCode
        versionName = currentVersionName
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            // Configured below if properties are provided
        }
    }

    if (releaseStoreFile != null &&
        releaseStorePassword != null &&
        releaseKeyAlias != null &&
        releaseKeyPassword != null) {

        signingConfigs.getByName("release") {
            storeFile = file(releaseStoreFile)
            storePassword = releaseStorePassword
            keyAlias = releaseKeyAlias
            keyPassword = releaseKeyPassword
        }
    }

    applicationVariants.all {
        val variantName = name
        val versionCodeValue = versionCode
        val versionNameValue = versionName

        outputs.all {
            val date = SimpleDateFormat("yyMMdd.HHmm").format(Date())
            val arch = filters.find {
                it.filterType == com.android.build.api.variant.FilterConfiguration.FilterType.ABI.name
            }?.identifier ?: "universal"
            val newName = "portfolio-$date-v$versionNameValue+$versionCodeValue-$variantName-$arch.apk"
            (this as BaseVariantOutputImpl).outputFileName = newName
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}