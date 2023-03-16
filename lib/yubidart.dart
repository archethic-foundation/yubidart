import 'package:yubidart/src/domain/protocol/protocol.dart';
import 'package:yubidart/src/domain/yubidart_platform_interface.dart';

export 'package:cryptography/dart.dart';

export 'src/domain/model/model.dart';
export 'src/domain/protocol/protocol.dart';
export 'src/infrastructure/yubidart_android.dart';
export 'src/infrastructure/yubidart_ios.dart';

class Yubidart {
  ConnectionProtocol get connection => YubidartPlatform.instance.connection;
}
