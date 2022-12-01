import 'package:flutter/services.dart';
import 'package:yubidart/src/domain/model/failure/failure.dart';

extension YKPlatformExceptionExt on PlatformException {
  YKFailure toYKFailure() {
    switch (code) {
      case 'INVALID_DATA':
        return const InvalidData();
      case 'ALREADY_CONNECTED':
        return const AlreadyConnectedFailure();
      case 'NOT_CONNECTED':
        return const NotConnectedFailure();
      case 'UNSUPPORTED_OPERATION':
        return UnsupportedOperation(message: message);
      case 'INVALID_PIN':
        return InvalidPin(remainingRetries: details as int);
      case 'INVALID_MANAGEMENT_KEY':
        return InvalidPIVManagementKey(message: message);
      case 'AUTH_METHOD_BLOCKED':
        return const AuthMethodBlocked();
      case 'SECURITY_CONDITION_NOT_SATISFIED':
        return const SecurityConditionNotSatisfied();
      case 'DEVICE_ERROR':
        return const DeviceError();
    }
    return const OtherFailure();
  }
}
