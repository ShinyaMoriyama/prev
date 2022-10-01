# Prev

An app that show the last time of your tasks.

## build.gradle

The plugin flutter_local_notifications requirements for Android:

```
android {
    compileSdkVersion 33

    defaultConfig {
      targetSdkVersion 33
      multiDexEnabled true
    }
}

dependencies {
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:1.1.5'

    // https://github.com/flutter/flutter/issues/110658
    implementation "androidx.window:window:1.1.0-alpha03"
    implementation "androidx.window:window-java:1.1.0-alpha03" // For Java-friendly APIs to register and unregister callbacks
    implementation "androidx.window:window-rxjava2:1.1.0-alpha03" // For RxJava2 integration
    implementation "androidx.window:window-rxjava3:1.1.0-alpha03" // For RxJava3 integration
    implementation "androidx.window:window-testing:1.1.0-alpha03" // For testing

}
```
