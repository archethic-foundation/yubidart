// Package imports:
import 'package:nfc_manager/nfc_manager.dart';

// Project imports:
import 'package:yubidart/src/nfc/unsupported_record.dart';
import 'package:yubidart/src/nfc/wellknown_uri_record.dart';

// ignore: avoid_classes_with_only_static_members
abstract class Record {
  static Record fromNdef(NdefRecord record) {
    if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown &&
        record.type.length == 1 &&
        record.type.first == 0x55) {
      return WellknownUriRecord.fromNdef(record);
    } else {
      return UnsupportedRecord(record);
    }
  }
}
