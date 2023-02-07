/// The touch policy of a private key defines whether or not a user presence
/// check (physical touch) is required to use the key.
/// Setting a Touch policy other than DEFAULT requires YubiKey 4 or later.
enum PivTouchPolicy {
  /// The default behavior for the particular key slot is used, which is always NEVER.
  defaultPolicy(0x0),

  /// Touch is never required for using the key.
  never(0x1),

  /// Touch is always required for using the key.
  always(0x2),

  /// Touch is required, but cached for 15s after use, allowing
  /// multiple uses. This setting requires YubiKey 4.3 or later.
  cached(0x3);

  const PivTouchPolicy(this.value);
  final int value;
}
