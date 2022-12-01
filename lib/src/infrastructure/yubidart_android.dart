import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yubidart/src/domain/model/general/device_capabilities.dart';
import 'package:yubidart/src/domain/protocol/general/protocol.dart';
import 'package:yubidart/src/domain/protocol/piv/protocol.dart';
import 'package:yubidart/src/domain/yubidart_platform_interface.dart';
import 'package:yubidart/src/infrastructure/protocol/piv/default_piv_protocol.dart';

/// An implementation of [YubidartPlatform] for Android.
class YubidartAndroid extends YubidartPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('net.archethic/yubidart');

  static void registerWith() {
    YubidartPlatform.instance = YubidartAndroid();
  }

  @override
  GeneralProtocol get general => DumbGeneralProtocol();

  @override
  PivProtocol get piv => DefaultPivProtocol();
}

class DumbGeneralProtocol implements GeneralProtocol {
  @override
  Future<DeviceCapabilities> get deviceCapabilities async =>
      const DeviceCapabilities(
        nfc: true,
        wired: true,
      );
}
