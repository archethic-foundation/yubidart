import 'dart:convert';
import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:flutter/services.dart';
import 'package:pem/pem.dart';
import 'package:yubidart/src/domain/model/model.dart';
import 'package:yubidart/src/domain/protocol/piv/protocol.dart';

class DefaultPivProtocol implements PivProtocol {
  /// The method channel used to interact with the native platform.
  // @foundation.visibleForTesting
  final methodChannel = const MethodChannel('net.archethic/yubidart');

  @override
  Future<Uint8List> generateKey({
    required PivSlot slot,
    required PivKeyType type,
    required PivPinPolicy pinPolicy,
    required PivTouchPolicy touchPolicy,
  }) =>
      YKFailure.guard(
        () async {
          final result = await methodChannel.invokeMethod<Uint8List>(
            'pivGenerateKey',
            <String, dynamic>{
              'slot': slot.value,
              'type': type.value,
              'pinPolicy': pinPolicy.value,
              'touchPolicy': touchPolicy.value,
            },
          );
          if (result == null) {
            throw YKFailure.other();
          }
          return result;
        },
      );

  @override
  Future<Uint8List> getCertificate({
    required PivSlot slot,
  }) =>
      YKFailure.guard(
        () async {
          final result = await methodChannel.invokeMethod<Uint8List>(
            'pivGetCertificate',
            <String, dynamic>{
              'slot': slot.value,
            },
          );
          log('result : ${json.encode(result)}');
          if (result == null) {
            throw YKFailure.other();
          }
          return result;
        },
      );

  @override
  Future<Uint8List> calculateSecret({
    required PivSlot slot,
    required String peerPublicKey,
  }) async {
    final result = await methodChannel.invokeMethod<Uint8List>(
      'pivCalculateSecret',
      <String, dynamic>{
        'slot': slot.value,
        'peerPublicKey': Uint8List.fromList(
          PemCodec(PemLabel.publicKey).decode(peerPublicKey),
        ),
      },
    );
    if (result == null) {
      throw YKFailure.other();
    }
    return result;
  }

  @override
  Future<PivProtocol> authenticate(PivManagementKey managementKey) async {
    final result = await methodChannel.invokeMethod<Uint8List>(
      'pivAuthenticate',
      <String, dynamic>{
        'managementKey': managementKey.key,
        'managementKeyType': managementKey.keyType.value,
      },
    );
    if (result == null) {
      throw YKFailure.other();
    }
    return this;
  }

  @override
  Future<PivProtocol> verifyPin(String pin) async {
    final result = await methodChannel.invokeMethod<Uint8List>(
      'pivVerifyPin',
      <String, dynamic>{
        'pin': pin,
      },
    );
    if (result == null) {
      throw YKFailure.other();
    }
    return this;
  }
}
