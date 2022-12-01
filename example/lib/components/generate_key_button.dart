import 'package:flutter/material.dart';
import 'package:yubidart/yubidart.dart';
import 'package:yubikit_android_example/components/action_button.dart';

class GenerateKeyButton extends StatelessWidget {
  const GenerateKeyButton({
    super.key,
    required this.yubikitPlugin,
  });

  final Yubidart yubikitPlugin;

  @override
  Widget build(BuildContext context) => ActionButton(
        text: 'Generate key',
        onPressed: () async {
          final publicKey = await yubikitPlugin.piv.generateKey(
            pin: "123456",
            managementKey: PivManagementKey.fromString(
              "010203040506070801020304050607080102030405060708",
              keyType: PivManagementKeyType.tripleDES,
            ),
            pinPolicy: PivPinPolicy.defaultPolicy,
            type: PivKeyType.eccp256,
            touchPolicy: PivTouchPolicy.defaultPolicy,
            slot: PivSlot.signature,
          );
          return publicKey.toString();
        },
      );
}
