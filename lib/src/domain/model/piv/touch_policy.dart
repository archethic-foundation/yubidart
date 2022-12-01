enum PivTouchPolicy {
  defaultPolicy(0x0),
  never(0x1),
  always(0x2),
  cached(0x3);

  const PivTouchPolicy(this.value);
  final int value;
}
