# parakey-sdk-flutter

The Parakey SDK allows your users to access features of the Parakey ecosystem within your application.

## Requirements

Minimum required Flutter version: `3.44`

## Installation

```yaml
dependencies:
  parakey_sdk_flutter:
    git:
      url: https://github.com/parakey-ab/parakey-sdk-flutter.git
      path: packages/parakey_sdk_flutter
      ref: 1.0.0
```

## Documentation

Documentation can be found in the Partner API specification and repositories for respective native package

- [Partner API](https://assets.parakey.co/api/partner/index.html)
- [Android](https://github.com/parakey-ab/parakey-sdk-android)
- [iOS](https://github.com/parakey-ab/parakey-sdk-ios)

Instructions below specify additional steps for each platform

## iOS

- Set the iOS deployment target of your `Runner` target to `15.1` or higher

- Parakey relies on background jobs which have to register handlers during application launch. A call to `Parakey.initialize()` must be present in your `AppDelegate`.

```diff
+ import parakey_sdk_flutter

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
+   Parakey.initialize()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
```

- Refer to the native [documentation](#documentation) and update your `Info.plist` with additional required properties

## Android

- Update your root `android/build.gradle.kts` with:

```diff
allprojects {
    repositories {
        google()
        mavenCentral()
+       maven {
+           url = uri("https://maven.pkg.github.com/parakey-ab/parakey-sdk-android")
+           credentials {
+               username = System.getenv("GITHUB_USER")
+               password = System.getenv("GITHUB_TOKEN")
+           }
+       }
    }
}
```

- Update your `android/app/build.gradle.kts` with:

```diff
defaultConfig {
-   minSdk = flutter.minSdkVersion
+   minSdk = 26
}
```

- Parakey must be initialized early in the application lifecycle via a call to `Parakey.initialize(this)` in the `onCreate` callback of the `Application`. Flutter does not generate an `Application`, create `MainApplication.kt` next to `MainActivity.kt`

```kotlin
package com.example.parakey_flutter_sample

import android.app.Application
import co.parakey.sdk.Parakey

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        Parakey.initialize(this)
    }
}
```

- Register the `Application` in your `AndroidManifest.xml`

```diff
<application
-   android:name="${applicationName}"
+   android:name=".MainApplication"
```

- Parakey presents its UI from a `ComponentActivity`. Your `MainActivity` must extend `FlutterFragmentActivity`

```diff
- import io.flutter.embedding.android.FlutterActivity
+ import io.flutter.embedding.android.FlutterFragmentActivity

- class MainActivity : FlutterActivity()
+ class MainActivity : FlutterFragmentActivity()
```

## Usage

```dart
import 'package:parakey_sdk_flutter/parakey_sdk_flutter.dart';

Future<void> setup() async {
  const tokenBundle = '....'; // acquired through partner API

  try {
    await Parakey.configure(tokenBundle);
  } catch (error) {
    handleError(error);
  }
}

Future<void> show() async {
  try {
    await Parakey.showScan();
  } catch (error) {
    handleError(error);
  }
}

Future<void> unlock() async {
  try {
    await Parakey.unlock('device-id');
  } catch (error) {
    handleError(error);
  }
}

void handleError(Object error) {
  if (error is ParakeyException) {
    debugPrint('Parakey error: ${error.code.name}');
  } else {
    debugPrint('Unknown error: $error');
  }
}

Future<void> cleanUp() async {
  await Parakey.deconfigure();
}

Future<void> theme() async {
  await Parakey.setTheme(
    const ParakeyTheme(
      actionLight: Color(0xFF0055FF),
      actionDark: Color(0xFF4499FF),
      titleLight: Color(0xFF111111),
      titleDark: Color(0xFFFFFFFF),
    ),
  );
}
```

## Error handling

Thrown errors carry a `ParakeyException` with a `code` (see the `ParakeyErrorCode` enum for all codes, and the native [documentation](#documentation) for their meaning).
Use an `on ParakeyException` clause to narrow a caught error:

```dart
import 'package:parakey_sdk_flutter/parakey_sdk_flutter.dart';

try {
  await Parakey.unlock('device-id');
} on ParakeyException catch (error) {
  debugPrint(error.code.name); // e.g. "unlockFailure"
}
```
