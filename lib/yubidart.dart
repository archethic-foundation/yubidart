import 'package:yubidart/src/domain/protocol/protocol.dart';
import 'package:yubidart/src/domain/yubidart_platform_interface.dart';

import 'src/infrastructure/protocol/otp/default_otp_protocol.dart';
import 'src/infrastructure/protocol/otp/yubicloud_client.dart';

export 'package:cryptography/dart.dart';

export 'src/domain/model/model.dart';
export 'src/domain/protocol/protocol.dart';
export 'src/infrastructure/yubidart_android.dart';
export 'src/infrastructure/yubidart_ios.dart';

class Yubidart {
  GeneralProtocol get general => YubidartPlatform.instance.general;

  OTPProtocol get otp => DefaultOTPProtocol(yubicloudClient: YubicloudClient());

  PivProtocol get piv => YubidartPlatform.instance.piv;
}
