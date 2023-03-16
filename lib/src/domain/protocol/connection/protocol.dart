import 'package:yubidart/yubidart.dart';

abstract class Connection {
  Future<PivProtocol> get pivSession;

  Future<OTPProtocol> get otpSession;
}

abstract class ConnectionProtocol {
  /// Looks at the device capabilities (connectivity mainly)
  Future<DeviceCapabilities> get deviceCapabilities;

  Future<Connection> connect({
    Duration timeout = const Duration(minutes: 1),
  });

  Future<void> disconnect();
}
