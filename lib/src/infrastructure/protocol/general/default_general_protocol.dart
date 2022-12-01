import 'package:flutter/services.dart';
import 'package:yubidart/src/domain/model/model.dart';
import 'package:yubidart/src/domain/protocol/general/protocol.dart';

class DefaultGeneralProtocol implements GeneralProtocol {
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
}
