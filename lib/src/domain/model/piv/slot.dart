/// A PIV-enabled YubiKey NEO holds 4 distinct slots for certificates and a
/// YubiKey 4 & 5 holds 24, as specified in the PIV standards document.
/// Each of these slots is capable of holding an X.509 certificate, together with its accompanying private key.
/// Technically these four slots are very similar, but they are used for different purposes.
///
/// https://developers.yubico.com/PIV/Introduction/Certificate_slots.html
enum PivSlot {
  /// This certificate and its associated private key is used to authenticate the card and the cardholder.
  /// This slot is used for things like system login. The end user PIN is required to perform any private key operations.
  /// Once the PIN has been provided successfully, multiple private key operations may be performed
  /// without additional cardholder consent.
  authentication(0x9a),

  /// This certificate and its associated private key is used for digital signatures for the purpose of document signing,
  /// or signing files and executables. The end user PIN is required to perform any private key operations.
  /// The PIN must be submitted every time immediately before a sign operation, to ensure cardholder participation
  /// for every digital signature generated.
  signature(0x9c),

  /// This certificate and its associated private key is used for encryption for the purpose of confidentiality.
  /// This slot is used for things like encrypting e-mails or files. The end user PIN is required to perform any private key
  /// operations.
  /// Once the PIN has been provided successfully, multiple private key operations may be performed without additional cardholder consent.
  management(0x9d),

  /// This certificate and its associated private key is used to support additional physical access applications, such
  /// as providing physical access to buildings via PIV-enabled door locks. The end user PIN is NOT required to perform
  /// private key operations for this slot.
  cardAuth(0x9e),

  /// This slot is only available on YubiKey version 4.3 and newer.
  /// It is only used for attestation of other keys generated on device with instruction f9.
  /// This slot is not cleared on reset, but can be overwritten.
  attestation(0xf9);

  const PivSlot(this.value);
  final int value;
}
