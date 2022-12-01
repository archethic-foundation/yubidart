enum PivManagementKeyType {
  tripleDES(0x03),
  aes128(0x08),
  aes192(0x0a),
  aes256(0x0c);

  const PivManagementKeyType(this.value);
  final int value;
}
