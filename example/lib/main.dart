import 'package:flutter/material.dart';
import 'package:yubidart/yubidart.dart';
import 'package:yubikit_android_example/components/capabilities_text.dart';
import 'package:yubikit_android_example/components/generate_key_button.dart';
import 'package:yubikit_android_example/components/piv_calculate_secret_button.dart';
import 'package:yubikit_android_example/components/piv_read_cert_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _yubikitPlugin = Yubidart();

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Yubikit example app'),
          ),
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CapabilitiesText(yubikitPlugin: _yubikitPlugin),
                ),
                GenerateKeyButton(yubikitPlugin: _yubikitPlugin),
                PivReadCertButton(yubikitPlugin: _yubikitPlugin),
                PivCalculateSecretButton(yubikitPlugin: _yubikitPlugin),
              ],
            ),
          ),
        ),
      );
}
