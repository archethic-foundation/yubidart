enum PivPinPolicy {
  defaultPolicy(0x0),
  never(0x1),
  once(0x2),
  always(0x3);

  const PivPinPolicy(this.value);
  final int value;
}
