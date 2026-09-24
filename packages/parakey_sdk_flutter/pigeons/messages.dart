import 'package:pigeon/pigeon.dart';

// Regenerate with: dart run pigeon --input pigeons/messages.dart
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    kotlinOut: 'android/src/main/kotlin/co/parakey/parakey_sdk_flutter/Messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'co.parakey.parakey_sdk_flutter'),
    swiftOut: 'ios/parakey_sdk_flutter/Sources/parakey_sdk_flutter/Messages.g.swift',
    dartPackageName: 'parakey_sdk_flutter',
  ),
)
/// Colors are 32-bit ARGB values, as returned by `Color.toARGB32()`.
class ThemeMessage {
  int? actionLight;
  int? actionDark;
  int? titleLight;
  int? titleDark;
}

@HostApi()
abstract class ParakeyHostApi {
  @async
  void configure(String tokenBundle);

  @async
  void deconfigure();

  @async
  void showScan();

  @async
  void unlock(String deviceId);

  void setTheme(ThemeMessage theme);
}
