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
          final certificate = await yubikitPlugin.piv.getCertificate(
            pin: "123456",
            slot: PivSlot.signature,
          );
          return String.fromCharCodes(certificate);
        },
      );
}
