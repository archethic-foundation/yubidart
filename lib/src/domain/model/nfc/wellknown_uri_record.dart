// Dart imports:
import 'dart:convert';
import 'dart:typed_data';

// Package imports:
import 'package:nfc_manager/nfc_manager.dart';
// Project imports:
import 'package:yubidart/src/domain/model/nfc/record.dart';

class WellknownUriRecord implements Record {
  WellknownUriRecord({this.identifier, required this.uri});

  final Uint8List? identifier;

  final Uri uri;

  static WellknownUriRecord fromNdef(NdefRecord record) {
    final String prefix = NdefRecord.URI_PREFIX_LIST[record.payload.first];
    final Uint8List bodyBytes = record.payload.sublist(1);
    return WellknownUriRecord(
      identifier: record.identifier,
      uri: Uri.parse(prefix + utf8.decode(bodyBytes)),
    );
  }
}
