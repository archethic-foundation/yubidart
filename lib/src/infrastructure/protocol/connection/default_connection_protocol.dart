import 'package:flutter/services.dart';
import 'package:yubidart/src/domain/model/failure/failure.dart';
import 'package:yubidart/src/domain/model/general/device_capabilities.dart';
import 'package:yubidart/src/domain/protocol/connection/protocol.dart';
import 'package:yubidart/src/domain/protocol/otp/otp.dart';
import 'package:yubidart/src/domain/protocol/piv/protocol.dart';
import 'package:yubidart/src/infrastructure/protocol/otp/default_otp_protocol.dart';
import 'package:yubidart/src/infrastructure/protocol/otp/yubicloud_client.dart';
import 'package:yubidart/src/infrastructure/protocol/piv/default_piv_protocol.dart';

class DefaultConnection implements Connection {
  @override
  Future<PivProtocol> get pivSession async => DefaultPivProtocol();

  @override
  Future<OTPProtocol> get otpSession async =>
      DefaultOTPProtocol(yubicloudClient: YubicloudClient());
}

class DefaultConnectionProtocol implements ConnectionProtocol {
  /// The method channel used to interact with the native platform.
  // @foundation.visibleForTesting
  final methodChannel = const MethodChannel('net.archethic/yubidart');

  @override
  Future<DeviceCapabilities> get deviceCapabilities => YKFailure.guard(
        () async {
          final supportsNFCScanning =
              await methodChannel.invokeMethod<bool>('supportsNFCScanning');
          final supportsISO7816NFCTags =
              await methodChannel.invokeMethod<bool>('supportsISO7816NFCTags');
          final supportsMFIAccessoryKey =
              await methodChannel.invokeMethod<bool>('supportsMFIAccessoryKey');

          if (supportsNFCScanning == null ||
              supportsISO7816NFCTags == null ||
              supportsMFIAccessoryKey == null) {
            throw YKFailure.other();
          }

          return DeviceCapabilities(
            nfc: supportsNFCScanning || supportsISO7816NFCTags,
            wired: supportsMFIAccessoryKey,
          );
        },
      );

  @override
  Future<Connection> connect({
    Duration timeout = const Duration(minutes: 1),
  }) {
    return YKFailure.guard(
      () async {
        await methodChannel.invokeMethod(
          'connect',
        );
        return DefaultConnection();
      },
    );
  }

  @override
  Future<void> disconnect() {
    return YKFailure.guard(
      () async {
        await methodChannel.invokeMethod(
          'disconnect',
        );
      },
    );
  }
}
