/// The verification response tells you whether the OTP is valid
/// See: https://developers.yubico.com/OTP/Specifications/OTP_validation_protocol.html
class OTPVerificationResponse {
  /// The OTP from the YubiKey, from request
  String? otp;

  /// Random unique data, from request
  String? nonce;

  /// Signature (base64)
  String? h;

  /// Timestamp in UTC
  String? t;

  /// The status of the operation, see below
  String status = '';

  /// YubiKey internal timestamp value when key was pressed
  String? timestamp;

  /// YubiKey internal usage counter when key was pressed
  String? sessionCounter;

  /// YubiKey internal session usage counter when key was pressed
  String? sessionuse;

  /// percentage of external validation server that replied successfully (0 to 100)
  int? sl;
}
