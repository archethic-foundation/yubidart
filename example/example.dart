import 'package:nfc_manager/nfc_manager.dart';
import 'package:yubidart/src/model/verification_response.dart';
import 'package:yubidart/yubidart.dart' show YubicoService;

Future<void> main(List<String> args) async {
  /// Verify if NFC is avalaible
  final bool isAvailable = await NfcManager.instance.isAvailable();
  if (isAvailable) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      final String otp = YubicoService().getOTPFromYubiKeyNFC(tag);

      /// Verify OTP with YubiCloud
      final VerificationResponse verificationResponse = await YubicoService()
          .verifyYubiCloudOTP(otp, 'mG5be6ZJU1qBGz24yPh/ESM3UdU=', '1');
      NfcManager.instance.stopSession();
      if (verificationResponse.status == 'OK') {
        print('OTP valid');
      } else {
        print('Error : ' + verificationResponse.status);
      }
    });
  }
}
