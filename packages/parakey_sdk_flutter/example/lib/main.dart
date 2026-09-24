import 'package:flutter/material.dart';
import 'package:parakey_sdk_flutter/parakey_sdk_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              const Text('Hello Parakey SDK'),
              ElevatedButton(
                onPressed: pressedConfigure,
                child: const Text('Configure'),
              ),
              ElevatedButton(
                onPressed: pressedShowScan,
                child: const Text('Show scan'),
              ),
              ElevatedButton(
                onPressed: pressedUnlock,
                child: const Text('Unlock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> pressedConfigure() async {
  const tokenBundle = 'example token'; // acquired through partner API

  try {
    await Parakey.setTheme(
      const ParakeyTheme(
        actionLight: Color(0xFFF2C0BD),
        titleLight: Color(0xFFE9F6CE),
      ),
    );
    await Parakey.configure(tokenBundle);
  } on ParakeyException catch (error) {
    debugPrint('Configure error: ${error.code.name}');
  } catch (error) {
    debugPrint('Unknown error: $error');
  }
}

Future<void> pressedShowScan() async {
  try {
    await Parakey.showScan();
  } on ParakeyException catch (error) {
    debugPrint('Show scan error: ${error.code.name}');
  }
}

Future<void> pressedUnlock() async {
  try {
    await Parakey.unlock('device-id');
  } on ParakeyException catch (error) {
    debugPrint('Unlock error: ${error.code.name}');
  }
}
