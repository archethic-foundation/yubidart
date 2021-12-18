import 'package:yubidart/yubidart.dart' show YubicoService;

Future<void> main(List<String> args) async {
  /// Verify OTP with YubiCloud
  const String otp = 'vvbbbbcggtlihvuckbitgibhcdvtblnkrvrkbhidifjn';
  const String apiKey = 'mG5be6ZJU1qBGz24yPh/ESM3UdU=';
  const String id = '1';
  final String responseStatus =
      await YubicoService().verifyYubiCloudOTP(otp, apiKey, id);
  if (responseStatus == 'OK') {
    print('OTP valid');
  } else {
    print('Error : ' + responseStatus);
  }
}
