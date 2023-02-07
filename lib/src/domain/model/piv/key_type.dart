/// Supported private key types for use with the PIV YubiKey application.
enum PivKeyType {
  /// RSA with a 1024 bit key.
  rsa1024(0x06),

  /// RSA with a 2048 bit key.
  rsa2048(0x07),

  /// Elliptic Curve key, using NIST Curve P-256.
  eccp256(0x11),

  /// Elliptic Curve key, using NIST Curve P-384.
  eccp384(0x14),

  unknown(0x00);

  const PivKeyType(this.value);
  final int value;
}
