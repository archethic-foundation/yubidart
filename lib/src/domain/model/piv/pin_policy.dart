/// The PIN policy of a private key defines whether or not a PIN is required to use the key.
/// Setting a PIN policy other than DEFAULT requires YubiKey 4 or later.
enum PivPinPolicy {
  /// The default behavior for the particular key slot is used.
  defaultPolicy(0x0),

  /// The PIN is never required for using the key.
  never(0x1),

  /// The PIN must be verified for the session, prior to using the key.
  once(0x2),

  /// The PIN must be verified each time the key is to be used, just prior to using it.
  always(0x3);

  const PivPinPolicy(this.value);
  final int value;
}
