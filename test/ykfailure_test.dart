// ignore: depend_on_referenced_packages
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yubidart/src/domain/model/failure/failure.dart';

Future<void> _shouldTransformPlatforException({
  required PlatformException platformException,
  required Matcher exceptionMatcher,
}) async {
  await expectLater(
    () => YKFailure.guard(
      () => throw platformException,
    ),
    throwsA(exceptionMatcher),
  );
}

void main() {
  group('YKFailure', () {
    group('Guard PlatformException', () {
      test(
        'Should transform code INVALID_DATA to InvalidData',
        () async {
          await _shouldTransformPlatforException(
            platformException: PlatformException(code: 'INVALID_DATA'),
            exceptionMatcher: isA<InvalidData>(),
          );
        },
      );

      test(
        'Should transform code ALREADY_CONNECTED to AlreadyConnectedFailure',
        () async {
          await _shouldTransformPlatforException(
            platformException: PlatformException(code: 'ALREADY_CONNECTED'),
            exceptionMatcher: isA<AlreadyConnectedFailure>(),
          );
        },
      );

      test(
        'Should transform code NOT_CONNECTED to NotConnectedFailure',
        () async {
          await _shouldTransformPlatforException(
            platformException: PlatformException(code: 'NOT_CONNECTED'),
            exceptionMatcher: isA<NotConnectedFailure>(),
          );
        },
      );

      test(
        'Should transform code UNSUPPORTED_OPERATION to UnsupportedOperation',
        () async {
          await _shouldTransformPlatforException(
            platformException: PlatformException(
              code: 'UNSUPPORTED_OPERATION',
              message: 'error description',
            ),
            exceptionMatcher: predicate(
              (e) =>
                  e is UnsupportedOperation && e.message == 'error description',
            ),
          );
        },
      );

      test(
        'Should transform code INVALID_PIN to InvalidPin',
        () async {
          await _shouldTransformPlatforException(
            platformException: PlatformException(
              code: 'INVALID_PIN',
              details: 3,
            ),
            exceptionMatcher: predicate(
              (e) => e is InvalidPin && e.remainingRetries == 3,
            ),
          );
        },
      );

      test(
        'Should transform code INVALID_MANAGEMENT_KEY to InvalidPIVManagementKey',
        () async {
          await _shouldTransformPlatforException(
            platformException: PlatformException(
              code: 'INVALID_MANAGEMENT_KEY',
            ),
            exceptionMatcher: isA<InvalidPIVManagementKey>(),
          );
        },
      );
      test(
        'Should transform code AUTH_METHOD_BLOCKED to AuthMethodBlocked',
        () async {
          await _shouldTransformPlatforException(
            platformException: PlatformException(
              code: 'AUTH_METHOD_BLOCKED',
            ),
            exceptionMatcher: isA<AuthMethodBlocked>(),
          );
        },
      );

      test(
        'Should transform code SECURITY_CONDITION_NOT_SATISFIED to SecurityConditionNotSatisfied',
        () async {
          await _shouldTransformPlatforException(
            platformException: PlatformException(
              code: 'SECURITY_CONDITION_NOT_SATISFIED',
            ),
            exceptionMatcher: isA<SecurityConditionNotSatisfied>(),
          );
        },
      );
      test(
        'Should transform code DEVICE_ERROR to DeviceError',
        () async {
          await _shouldTransformPlatforException(
            platformException: PlatformException(
              code: 'DEVICE_ERROR',
            ),
            exceptionMatcher: isA<DeviceError>(),
          );
        },
      );
    });
  });
}
