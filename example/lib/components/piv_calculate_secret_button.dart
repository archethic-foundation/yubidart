import 'package:flutter/material.dart';
import 'package:yubidart/yubidart.dart';
import 'package:yubikit_android_example/components/action_button.dart';

class PivCalculateSecretButton extends StatelessWidget {
  const PivCalculateSecretButton({
    super.key,
    required this.yubikitPlugin,
  });

  final Yubidart yubikitPlugin;

  @override
  Widget build(BuildContext context) => ActionButton(
        text: 'Calculate secret',
        onPressed: () async {
          final secret = await yubikitPlugin.piv.calculateSecret(
            slot: PivSlot.authentication,
            pin: "123456",
            peerPublicKey: """
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAElqeFrBCjtonol5ksKYCuXf+alUTI
60I0O7layDn75ar9UnvTnCmywrsp/434Mg5R7+02W1glNilGvW4pHfUWNA==
-----END PUBLIC KEY-----
""",
          );
          return secret.toString();
        },
      );
}
