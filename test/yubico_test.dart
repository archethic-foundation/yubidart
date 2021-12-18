library test.yubico_test;

// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:yubidart/src/services/yubico_service.dart';

void main() {
  group('yubicoService', () {
    test('verifySignatures', () async {
      final String responseStatus = await YubicoService().verifyYubiCloudOTP(
          'vvcccbcgdulihvuckbitgibhcdvtblnkrvrkbhidifjn',
          'oxz9OVJdNgodAcgWL7QG5BXkqh4=',
          '70258');
      expect(responseStatus, 'OK');
    });
  }, tags: <String>['noCI']);
}
