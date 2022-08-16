library test.yubico_test;

// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:yubidart/src/model/verification_response.dart';
import 'package:yubidart/src/services/yubico_service.dart';

void main() {
  group('yubicoService', () {
    test('verifySignatures', () async {
      final VerificationResponse verificationResponse = await YubicoService()
          .verifyYubiCloudOTP('vvbbbbcggtlihvuckbitgibhcdvtblnkrvrkbhidifjn',
              'mG5be6ZJU1qBGz24yPh/ESM3UdU=', '1');
      expect(verificationResponse.status, 'OK');
    }, tags: <String>['noCI']);

    test('ciOk', () {
      expect(true, true);
    });
  });
}
