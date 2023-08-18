// Package imports:
import 'package:nfc_manager/nfc_manager.dart';
// Project imports:
import 'package:yubidart/src/domain/model/nfc/record.dart';

class UnsupportedRecord implements Record {
  UnsupportedRecord(this.record);

  final NdefRecord record;

  // ignore: prefer_constructors_over_static_methods
  static UnsupportedRecord fromNdef(NdefRecord record) {
    return UnsupportedRecord(record);
  }
}
