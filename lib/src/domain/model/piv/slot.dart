enum PivSlot {
  authentication(0x9a),
  signature(0x9c),
  management(0x9d),
  cardAuth(0x9e),
  attestation(0xf9);

  const PivSlot(this.value);
  final int value;
}
