import 'package:yubidart/yubidart.dart';

extension YKFailureMessageExt on YKFailure {
  String get message {
    if (this is InvalidPin) {
      return "Invalid pin. ${(this as InvalidPin).remainingRetries} tries remaining.";
    }

    if (this is InvalidPIVManagementKey) {
      return "Invalid management key. ${(this as InvalidPIVManagementKey).message}.";
    }

    if (this is UnsupportedOperation) {
      return "Unsupported operation";
    }

    if (this is NotConnectedFailure) {
      return "Connection to Yubikey failed";
    }

    return "An error occured";
  }
}
