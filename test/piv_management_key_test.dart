import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:yubidart/src/domain/model/failure/failure.dart';
import 'package:yubidart/src/domain/model/piv/management_key.dart';
import 'package:yubidart/src/domain/model/piv/management_key_type.dart';

void main() {
  group('PIV Management key', () {
    group('Build from String', () {
      test(
        'Should succeed with valid key',
        () async {
          final managementKey = PivManagementKey.fromString(
            '000102030405060708090A0B0C0D0E0F1011121314151617',
            keyType: PivManagementKeyType.aes128,
          );

          expect(
            managementKey.key,
            Uint8List.fromList([
              0,
              1,
              2,
              3,
              4,
              5,
              6,
              7,
              8,
              9,
              10,
              11,
              12,
              13,
              14,
              15,
              16,
              17,
              18,
              19,
              20,
              21,
              22,
              23,
            ]),
          );

          expect(
            managementKey.keyType,
            PivManagementKeyType.aes128,
          );
        },
      );

      test(
        'Should reject when length != 48 characters',
        () async {
          expect(
            () => PivManagementKey.fromString(
              '0123456',
              keyType: PivManagementKeyType.aes128,
            ),
            throwsA(
              predicate(
                (Object? e) =>
                    e is InvalidPIVManagementKey &&
                    e.message == 'Key should be 48 characters length',
              ),
            ),
          );
        },
      );

      test(
        'Should reject non-hexadecimal characters',
        () async {
          expect(
            () => PivManagementKey.fromString(
              '00000000000000000000000000000000000000000000000v',
              keyType: PivManagementKeyType.aes128,
            ),
            throwsA(
              predicate(
                (Object? e) =>
                    e is InvalidPIVManagementKey &&
                    e.message ==
                        'Key should contain hexadecimal characters only',
              ),
            ),
          );
        },
      );
    });
  });
}
