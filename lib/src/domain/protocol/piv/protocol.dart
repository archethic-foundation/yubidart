import 'package:flutter/services.dart';
import 'package:yubidart/src/domain/model/piv/key_type.dart';
import 'package:yubidart/src/domain/model/piv/management_key.dart';
import 'package:yubidart/src/domain/model/piv/pin_policy.dart';
import 'package:yubidart/src/domain/model/piv/slot.dart';
import 'package:yubidart/src/domain/model/piv/touch_policy.dart';

abstract class PivProtocol {
  /// Generates a new key pair within the YubiKey.
  /// This method requires authentication and pin verification.
  ///
  /// YubiKey FIPS does not allow RSA1024 nor PinProtocol.NEVER.
  /// RSA key types require RSA generation, available on YubiKeys OTHER THAN 4.2.6-4.3.4.
  /// KeyType P348 requires P384 support, available on YubiKey 4 or later.
  /// PinPolicy or TouchPolicy other than default require support for usage policy, available on YubiKey 4 or later.
  /// TouchPolicy.CACHED requires support for touch cached, available on YubiKey 4.3 or later.
  /// This method is thread safe and can be invoked from any thread (main or a background thread).
  ///
  /// [pin] The pin. Default pin code is 123456.
  /// [managementKey] The management key. Default is 010203040506070801020304050607080102030405060708.
  /// [slot] The slot to generate the new key in.
  /// [type] Which algorithm is used for key generation.
  /// [pinPolicy] The PIN policy for using the private key.
  /// [touchPolicy] The touch policy for using the private key.
  ///
  /// Returns the public key of the generated key pair
  ///
  /// Throws a [YKFailure]
  Future<Uint8List> generateKey({
    required String pin,
    required PivManagementKey managementKey,
    required PivSlot slot,
    required PivKeyType type,
    required PivPinPolicy pinPolicy,
    required PivTouchPolicy touchPolicy,
  });

  /// Reads the X.509 certificate stored in the specified slot on the YubiKey.
  ///
  /// [pin] The pin. Default pin code is 123456.
  /// [slot] : The slot where the certificate is stored.
  ///
  /// Returns certificate instance
  ///
  /// Throws a [YKFailure]
  Future<Uint8List> getCertificate({
    required String pin,
    required PivSlot slot,
  });

  /// Perform an ECDH operation with a given public key to compute a shared secret.
  ///
  /// [pin] The pin. Default pin code is 123456.
  /// [slot] The slot containing the private EC key to use.
  /// [peerPublicKey] The peer public key for the operation. This is an EllipticCurve encryption public key in PEM format.
  ///
  /// Returns the shared secret, comprising the x-coordinate of the ECDH result point.
  ///
  /// Throws a [YKFailure]
  Future<Uint8List> calculateSecret({
    required String pin,
    required PivSlot slot,
    required String peerPublicKey,
  });
}
