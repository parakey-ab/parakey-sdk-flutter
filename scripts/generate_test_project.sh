#!/bin/bash

# Interactive steps for setting up a fresh Flutter project with the Parakey Flutter SDK
#
# NOTE:
#   Automating this fully with git patches turned out complicated as different Flutter verions
#   vary their file content just enough to make generating clean patches not possible

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

echo "Setup a new flutter project"
echo_green "flutter create parakey_flutter_sample"
prompt_enter_to_continue

echo "Add the Flutter adapter to pubspec.yaml 'dependencies', set version accordingly"
text="$(cat <<'EOF'
  parakey_sdk_flutter:
    git:
      url: https://github.com/parakey-ab/parakey-sdk-flutter.git
      path: packages/parakey_sdk_flutter
      ref: 1.0.0
EOF
)"
echo_green "$text"
prompt_enter_to_continue

echo "Set the iOS deployment target of the 'Runner' target to 15.1"
prompt_enter_to_continue

echo "Add to Info.plist dict"
text="$(cat <<'EOF'
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
	<string>co.parakey.updateSecurity</string>
	<string>co.parakey.updateAccess</string>
</array>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Parakey uses Bluetooth in order to discover and interact with locks</string>
<key>NSFaceIDUsageDescription</key>
<string>Certain locks require biometric authentication in order to unlock</string>
<key>UIBackgroundModes</key>
<array>
	<string>bluetooth-central</string>
	<string>processing</string>
	<string>fetch</string>
</array>
EOF
)"
echo_green "$text"
prompt_enter_to_continue

echo "Add to app delegate"
echo_green "import parakey_sdk_flutter"
echo_green "Parakey.initialize()"
prompt_enter_to_continue

echo "Add to root android/build.gradle.kts"
text="$(cat <<'EOF'
allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.pkg.github.com/parakey-ab/parakey-sdk-android")
            credentials {
                username = System.getenv("GITHUB_USER")
                password = System.getenv("GITHUB_TOKEN")
            }
        }
    }
}
EOF
)"
echo_green "$text"
prompt_enter_to_continue

echo "Set minSdk in defaultConfig in android/app/build.gradle.kts"
echo_green 'minSdk = 26'
prompt_enter_to_continue

echo "Flutter generates no Application, create MainApplication.kt next to MainActivity.kt"
text="$(cat <<'EOF'
package com.example.parakey_flutter_sample

import android.app.Application
import co.parakey.sdk.Parakey

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        Parakey.initialize(this)
    }
}
EOF
)"
echo_green "$text"
prompt_enter_to_continue

echo "Register it in AndroidManifest.xml, replacing the applicationName placeholder"
echo_grey '<application'
echo_grey '    android:name="${applicationName}"'
echo_green '    android:name=".MainApplication"'
prompt_enter_to_continue

echo "Change the MainActivity superclass"
echo_grey "import io.flutter.embedding.android.FlutterActivity"
echo_green "import io.flutter.embedding.android.FlutterFragmentActivity"
echo_grey "class MainActivity : FlutterActivity()"
echo_green "class MainActivity : FlutterFragmentActivity()"
prompt_enter_to_continue

echo_green "Copy over the content of main.dart"
prompt_enter_to_continue

echo "Run install commands"
echo_green "flutter pub get"
prompt_enter_to_continue
