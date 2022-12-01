import 'package:yubidart/src/domain/model/general/device_capabilities.dart';

abstract class GeneralProtocol {
  /// Looks at the device capabilities (connectivity mainly)
  Future<DeviceCapabilities> get deviceCapabilities;
}
