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
          final connection = await yubikitPlugin.connection.connect();
          final piv = await connection.pivSession;

          piv.verifyPin("123456");

          final secret = await piv.calculateSecret(
            slot: PivSlot.authentication,
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
