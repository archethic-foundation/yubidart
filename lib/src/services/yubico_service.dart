// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

// Package imports:
import 'package:crypto/crypto.dart' as crypto show Hmac, sha1, Digest;
import 'package:http/http.dart' as http show Response, get;
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nonce/nonce.dart';
import 'package:yubidart/src/nfc/record.dart';
import 'package:yubidart/src/nfc/wellknown_uri_record.dart';

class YubicoService {
  /// Verify OTP with YubiCloud
  /// @param {String} [otp] The OTP from the YubiKey.
  /// @param {String} [apiKey]
  /// @param {String} [id] Specifies the requestor so that the end-point can retrieve correct shared secret for signing the response.
  /// @param {int} [timeout] (optional) Number of seconds to wait for sync responses; if absent, let the server decide
  /// @param {String} [sl] (optional) A value 0 to 100 indicating percentage of syncing required by client, or strings "fast" or "secure" to use server-configured values; if absent, let the server decide
  /// @param {String} [timestamp] (optional) Timestamp=1 requests timestamp and session counter information in the response
  Future<String> verifyYubiCloudOTP(String otp, String apiKey, String id,
      {int? timeout, String? sl, String? timestamp}) async {
    String responseStatus = 'KO';
    try {
      final Uint8List apiKeyDecode64 = base64.decode(apiKey);

      /// A 16 to 40 character long string with random unique data
      final String nonce = Nonce.generate(Random().nextInt(25) + 16);

      String keyValue = 'id=' + id + '&nonce=' + nonce + '&otp=' + otp;
      if (sl != null) {
        keyValue = keyValue + '&sl=' + sl;
      }
      if (timeout != null) {
        keyValue = keyValue + '&timeout=' + timeout.toString();
      }
      if (timestamp != null) {
        keyValue = keyValue + '&timestamp=' + timestamp;
      }
      final crypto.Hmac hmacSha1 = crypto.Hmac(crypto.sha1, apiKeyDecode64);
      final crypto.Digest sha1Result = hmacSha1.convert(keyValue.codeUnits);

      /// The optional HMAC-SHA1 signature for the request.
      final String hEncode64 = base64.encode(sha1Result.bytes);

      final http.Response responseHttp = await http.get(
        Uri.parse('https://api.yubico.com/wsapi/2.0/verify?' +
            keyValue +
            '&h=' +
            hEncode64),
      );
      bool nonceOk = false;
      bool otpOk = false;
      bool hOk = false;
      String h = '';
      if (responseHttp.statusCode == 200) {
        final Uri uri = Uri.parse(Uri.encodeFull(
            'https://api.yubico.com/wsapi/2.0/verify?' +
                responseHttp.body.replaceAll('\n', '&').replaceAll('\r', '')));
        // ignore: prefer_final_locals
        List<String> responseParams = List<String>.empty(growable: true);
        uri.queryParameters.forEach((String k, String v) {
          if (k == 'status') {
            responseStatus = v.trim();
          }
          if (k == 'nonce' && v.trim() == nonce) {
            nonceOk = true;
          }
          if (k == 'otp' && v.trim() == otp) {
            otpOk = true;
          }
          if (k == 'h') {
            h = v.trim();
          }
          responseParams.add(k + '=' + v);
        });
        responseParams
            .sort((String a, String b) => a.toString().compareTo(b.toString()));
        bool first = true;
        for (String element in responseParams) {
          element.replaceAll('\r\n', '');
          if (element.startsWith('h=') == false) {
            if (first) {
              keyValue = element;
              first = false;
            } else {
              keyValue = keyValue + '&' + element;
            }
          }
        }

        if (responseStatus == 'OK') {
          final crypto.Digest responseSha1Result =
              hmacSha1.convert(keyValue.codeUnits);
          final String responseHEncode64 =
              base64.encode(responseSha1Result.bytes);
          if (responseHEncode64 == h) {
            hOk = true;
          }
          if (!nonceOk || !otpOk || !hOk) {
            responseStatus = 'RESPONSE_KO';
          }
        }
      }
    } catch (e) {
      responseStatus = 'RESPONSE_KO';
    }
    return responseStatus;
  }

  /// Get OTP from NFC YubiKey
  /// @param {NfcTag} [tag] Tag discovered by the session
  String getOTPFromYubiKeyNFC(NfcTag tag) {
    final Ndef? tech = Ndef.from(tag);
    final NdefMessage? cachedMessage = tech!.cachedMessage;
    String otp = '';
    if (cachedMessage != null) {
      for (int i in Iterable.generate(cachedMessage.records.length)) {
        final NdefRecord record = cachedMessage.records[i];
        final Record _record = Record.fromNdef(record);
        if (_record is WellknownUriRecord) {
          otp = '${_record.uri}';
          otp = otp.split('#')[1];
        }
      }
    }
    return otp;
  }

  /// Verify from NFC Yubikey the OTP
  /// @param {NfcTag} [tag] Tag discovered by the session
  /// @param {String} [apiKey]
  /// @param {String} [id] Specifies the requestor so that the end-point can retrieve correct shared secret for signing the response.
  /// @param {int} [timeout] (optional) Number of seconds to wait for sync responses; if absent, let the server decide
  /// @param {String} [sl] (optional) A value 0 to 100 indicating percentage of syncing required by client, or strings "fast" or "secure" to use server-configured values; if absent, let the server decide
  /// @param {String} [timestamp] (optional) Timestamp=1 requests timestamp and session counter information in the response
  Future<String> verifyOTPFromYubiKeyNFC(NfcTag tag, String apiKey, String id,
      {int? timeout, String? sl, String? timestamp}) async {
    final String otp = getOTPFromYubiKeyNFC(tag);
    if (otp.isEmpty) {
      return 'OTP_NOT_FOUND';
    } else {
      final String responseStatus = await verifyYubiCloudOTP(otp, apiKey, id,
          timeout: timeout, sl: sl, timestamp: timestamp);
      if (responseStatus == 'OK') {
        return otp;
      } else {
        return responseStatus;
      }
    }
  }
}
