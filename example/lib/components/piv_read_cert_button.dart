import 'package:flutter/material.dart';
import 'package:yubidart/yubidart.dart';
import 'package:yubikit_android_example/components/action_button.dart';

class PivReadCertButton extends StatelessWidget {
  const PivReadCertButton({
    super.key,
    required this.yubikitPlugin,
  });

  final Yubidart yubikitPlugin;

  @override
  Widget build(BuildContext context) => ActionButton(
        text: 'Read certificate',
        onPressed: () async {
          final connection = await yubikitPlugin.connection.connect();
          final piv = await connection.pivSession;
          await piv.verifyPin("123456");
          final publicKey = await piv.getCertificate(
            slot: PivSlot.signature,
          );
          return String.fromCharCodes(publicKey);
        },
      );
}
