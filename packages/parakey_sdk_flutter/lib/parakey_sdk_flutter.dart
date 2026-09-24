import 'package:flutter/services.dart';

import 'src/messages.g.dart';

enum ParakeyErrorCode {
  invalidCredentials,
  invalidTokenBundle,
  configureFailure,
  sessionMissing,
  accessNotFound,
  unlockCanceled,
  unlockFailure,
  operationInProgress,
  noAndroidActivity;

  static ParakeyErrorCode? fromId(String id) => values.asNameMap()[id];
}

class ParakeyException implements Exception {
  const ParakeyException(this.code);

  final ParakeyErrorCode code;

  @override
  String toString() => 'ParakeyException(${code.name})';
}

class ParakeyTheme {
  const ParakeyTheme({
    this.actionLight,
    this.actionDark,
    this.titleLight,
    this.titleDark,
  });

  final Color? actionLight;
  final Color? actionDark;
  final Color? titleLight;
  final Color? titleDark;
}

class Parakey {
  Parakey._();

  static final _api = ParakeyHostApi();

  static Future<void> configure(String tokenBundle) =>
      _mapPlatformException(() => _api.configure(tokenBundle));

  static Future<void> deconfigure() => _mapPlatformException(_api.deconfigure);

  static Future<void> showScan() => _mapPlatformException(_api.showScan);

  static Future<void> unlock(String deviceId) =>
      _mapPlatformException(() => _api.unlock(deviceId));

  static Future<void> setTheme(ParakeyTheme theme) => _mapPlatformException(
    () => _api.setTheme(
      ThemeMessage(
        actionLight: theme.actionLight?.toARGB32(),
        actionDark: theme.actionDark?.toARGB32(),
        titleLight: theme.titleLight?.toARGB32(),
        titleDark: theme.titleDark?.toARGB32(),
      ),
    ),
  );

  static Future<void> _mapPlatformException(Future<void> Function() call) async {
    try {
      await call();
    } on PlatformException catch (e) {
      final code = ParakeyErrorCode.fromId(e.code);
      if (code == null) rethrow;
      throw ParakeyException(code);
    }
  }
}
