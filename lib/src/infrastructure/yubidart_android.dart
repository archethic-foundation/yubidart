import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yubidart/src/domain/protocol/connection/protocol.dart';
import 'package:yubidart/src/domain/yubidart_platform_interface.dart';
import 'package:yubidart/src/infrastructure/protocol/connection/default_connection_protocol.dart';

/// An implementation of [YubidartPlatform] for Android.
class YubidartAndroid extends YubidartPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('net.archethic/yubidart');

  static void registerWith() {
    YubidartPlatform.instance = YubidartAndroid();
  }

  @override
  ConnectionProtocol get connection => DefaultConnectionProtocol();
}
