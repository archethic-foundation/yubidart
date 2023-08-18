import 'dart:typed_data';

import 'package:yubidart/src/domain/model/failure/failure.dart';
import 'package:yubidart/src/domain/model/piv/management_key_type.dart';

class PivManagementKey {
  const PivManagementKey({
    required this.key,
    required this.keyType,
  });

  factory PivManagementKey.fromString(
    String key, {
    required PivManagementKeyType keyType,
  }) {
    if (key.length != 48) {
      throw YKFailure.invalidPIVManagementKey(
        message: 'Key should be 48 characters length',
      );
    }

    if (key.contains(RegExp('[^a-fA-F0-9]'))) {
      throw YKFailure.invalidPIVManagementKey(
        message: 'Key should contain hexadecimal characters only',
      );
    }

    final hexaKey = Uint8List(24);
    for (var i = 0; i < key.length; i += 2) {
      final digit = int.parse(
        key.substring(i, i + 2),
        radix: 16,
      );
      hexaKey[i ~/ 2] = digit;
    }
    return PivManagementKey(
      key: hexaKey,
      keyType: keyType,
    );
  }
  final Uint8List key;
  final PivManagementKeyType keyType;
}
