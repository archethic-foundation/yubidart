import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:yubidart/src/domain/model/failure/failure_ext.dart';

abstract class YKFailure implements Exception {
  const YKFailure();

  static Future<T> guard<T>(FutureOr<T> Function() run) async {
    try {
      return await run();
    } on PlatformException catch (e, stack) {
      log(
        'An error occured',
        name: 'Yubidart',
        error: e,
        stackTrace: stack,
      );
      throw e.toYKFailure();
    }
  }

  factory YKFailure.invalidPIVManagementKey({
    String? message,
  }) = InvalidPIVManagementKey;

  factory YKFailure.securityConditionNotSatisfied() =
      SecurityConditionNotSatisfied;

  factory YKFailure.invalidPin({
    required int remainingRetries,
  }) = InvalidPin;

  factory YKFailure.authMethodBlocked() = AuthMethodBlocked;

  factory YKFailure.unsupportedOperation({
    String? message,
  }) = UnsupportedOperation;

  factory YKFailure.deviceError() = DeviceError;

  factory YKFailure.notConnected() = NotConnectedFailure;

  factory YKFailure.invalidData() = InvalidData;

  factory YKFailure.other() = OtherFailure;
}

class InvalidPIVManagementKey extends YKFailure {
  final String? message;
  const InvalidPIVManagementKey({
    this.message,
  });
}

class SecurityConditionNotSatisfied extends YKFailure {
  const SecurityConditionNotSatisfied();
}

class InvalidPin extends YKFailure {
  final int remainingRetries;

  const InvalidPin({
    required this.remainingRetries,
  });
}

class AuthMethodBlocked extends YKFailure {
  const AuthMethodBlocked();
}

class DeviceError extends YKFailure {
  const DeviceError();
}

class UnsupportedOperation extends YKFailure {
  final String? message;

  const UnsupportedOperation({
    this.message,
  });
}

class NotConnectedFailure extends YKFailure {
  const NotConnectedFailure();
}

class AlreadyConnectedFailure extends YKFailure {
  const AlreadyConnectedFailure();
}

class InvalidData extends YKFailure {
  const InvalidData();
}

class OtherFailure extends YKFailure {
  const OtherFailure();
}
