import 'package:nfc_manager/nfc_manager.dart';
import 'package:yubidart/src/domain/model/otp/verification_response.dart';

abstract class OTPProtocol {
  const OTPProtocol();

  /// Get OTP from NFC YubiKey
  /// @param {NfcTag} [tag] Tag discovered by the session
  String getOTPFromYubiKeyNFC(NfcTag tag);

  /// Verify from NFC Yubikey the OTP
  /// @param {NfcTag} [tag] Tag discovered by the session
  /// @param {String} [apiKey]
  /// @param {String} [id] Specifies the requestor so that the end-point can retrieve correct shared secret for signing the response.
  /// @param {int} [timeout] (optional) Number of seconds to wait for sync responses; if absent, let the server decide
  /// @param {String} [sl] (optional) A value 0 to 100 indicating percentage of syncing required by client, or strings "fast" or "secure" to use server-configured values; if absent, let the server decide
  /// @param {String} [timestamp] (optional) Timestamp=1 requests timestamp and session counter information in the response
  Future<OTPVerificationResponse> verifyOTPFromYubiKeyNFC(
    NfcTag tag,
    String apiKey,
    String id, {
    int? timeout,
    String? sl,
    String? timestamp,
  });

  /// Verify OTP with YubiCloud
  /// https://developers.yubico.com/OTP/Specifications/OTP_validation_protocol.html
  /// @param {String} [otp] The OTP from the YubiKey.
  /// @param {String} [apiKey]
  /// @param {String} [id] Specifies the requestor so that the end-point can retrieve correct shared secret for signing the response.
  /// @param {int} [timeout] (optional) Number of seconds to wait for sync responses; if absent, let the server decide
  /// @param {String} [sl] (optional) A value 0 to 100 indicating percentage of syncing required by client, or strings "fast" or "secure" to use server-configured values; if absent, let the server decide
  /// @param {String} [timestamp] (optional) Timestamp=1 requests timestamp and session counter information in the response
  Future<OTPVerificationResponse> verify(
    String otp,
    String apiKey,
    String id, {
    int? timeout,
    String? sl,
    String? timestamp,
  });
}
