import 'package:flutter_test/flutter_test.dart';
import 'package:yubidart/src/domain/model/otp/verification_response.dart';
import 'package:yubidart/src/infrastructure/protocol/otp/yubicloud_client.dart';

void main() {
  group('YubicloudClient', () {
    test(
      'verifySignatures',
      () async {
        final OTPVerificationResponse verificationResponse =
            await YubicloudClient().verify(
          otp: 'vvbbbbcggtlihvuckbitgibhcdvtblnkrvrkbhidifjn',
          apiKey: 'mG5be6ZJU1qBGz24yPh/ESM3UdU=',
          id: '1',
        );
        expect(verificationResponse.status, 'OK');
      },
      tags: <String>['noCI'],
    );
  });
}
