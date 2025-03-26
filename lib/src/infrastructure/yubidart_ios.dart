import 'package:yubidart/src/domain/protocol/connection/protocol.dart';
import 'package:yubidart/src/domain/yubidart_platform_interface.dart';
import 'package:yubidart/src/infrastructure/protocol/connection/default_connection_protocol.dart';

/// An implementation of [YubidartPlatform] that uses method channels.
class YubidartIos extends YubidartPlatform {
  static void registerWith() {
    YubidartPlatform.instance = YubidartIos();
  }

  @override
  ConnectionProtocol get connection => DefaultConnectionProtocol();
}
