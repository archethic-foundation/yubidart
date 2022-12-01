enum PivKeyType {
  rsa1024(0x06),
  rsa2048(0x07),
  eccp256(0x11),
  eccp384(0x14),
  unknown(0x00);

  const PivKeyType(this.value);
  final int value;
}
