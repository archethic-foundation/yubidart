import 'package:yubidart/src/domain/protocol/general/protocol.dart';
import 'package:yubidart/src/domain/protocol/piv/protocol.dart';
import 'package:yubidart/src/domain/yubidart_platform_interface.dart';
import 'package:yubidart/src/infrastructure/protocol/general/default_general_protocol.dart';
import 'package:yubidart/src/infrastructure/protocol/piv/default_piv_protocol.dart';

/// An implementation of [YubidartPlatform] that uses method channels.
class YubidartIos extends YubidartPlatform {
  static void registerWith() {
    YubidartPlatform.instance = YubidartIos();
  }

  @override
  GeneralProtocol get general => DefaultGeneralProtocol();

  @override
  PivProtocol get piv => DefaultPivProtocol();
}
