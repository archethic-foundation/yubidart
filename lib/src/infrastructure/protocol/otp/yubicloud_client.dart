import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:nonce/nonce.dart';
import 'package:yubidart/src/domain/model/otp/verification_response.dart';

class YubicloudClient {
  Future<OTPVerificationResponse> verify({
    required String otp,
    required String apiKey,
    required String id,
    int? timeout,
    String? sl,
    String? timestamp,
  }) async {
    final verificationResponse = OTPVerificationResponse();
    try {
      final apiKeyDecode64 = base64.decode(apiKey);

      /// A 16 to 40 character long string with random unique data
      final nonce = Nonce.generate(Random().nextInt(25) + 16);

      String keyValue = 'id=$id&nonce=$nonce&otp=$otp';
      if (sl != null) {
        keyValue = '$keyValue&sl=$sl';
      }
      if (timeout != null) {
        keyValue = '$keyValue&timeout=$timeout';
      }
      if (timestamp != null) {
        keyValue = '$keyValue&timestamp=$timestamp';
      }
      final crypto.Hmac hmacSha1 = crypto.Hmac(crypto.sha1, apiKeyDecode64);
      final crypto.Digest sha1Result = hmacSha1.convert(keyValue.codeUnits);

      /// The optional HMAC-SHA1 signature for the request.
      final hEncode64 = base64.encode(sha1Result.bytes);

      final http.Response responseHttp = await http.get(
        Uri.parse(
            'https://api.yubico.com/wsapi/2.0/verify?$keyValue&h=$hEncode64'),
      );
      bool nonceOk = false;
      bool otpOk = false;
      bool hOk = false;
      String h = '';
      if (responseHttp.statusCode == 200) {
        final uri = Uri.parse(Uri.encodeFull(
            'https://api.yubico.com/wsapi/2.0/verify?${responseHttp.body.replaceAll('\n', '&').replaceAll('\r', '')}'));
        final responseParams = List<String>.empty(growable: true);
        uri.queryParameters.forEach((String k, String v) {
          if (k == 'status') {
            verificationResponse.status = v.trim();
          }
          if (k == 'nonce' && v.trim() == nonce) {
            nonceOk = true;
            verificationResponse.nonce = v.trim();
          }
          if (k == 'otp' && v.trim() == otp) {
            otpOk = true;
            verificationResponse.otp = v.trim();
          }
          if (k == 'h') {
            h = v.trim().replaceAll(' ', '+');
            verificationResponse.h = v.trim();
          }
          if (k == 't') {
            verificationResponse.t = v.trim();
          }
          if (k == 'timestamp') {
            verificationResponse.timestamp = v.trim();
          }
          if (k == 'sessioncounter') {
            verificationResponse.sessionCounter = v.trim();
          }
          if (k == 'sessionuse') {
            verificationResponse.sessionuse = v.trim();
          }
          if (k == 'sl') {
            verificationResponse.sl = int.tryParse(v.trim());
          }
          responseParams.add('$k=$v');
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
              keyValue = '$keyValue&$element';
            }
          }
        }

        if (verificationResponse.status == 'OK') {
          final crypto.Digest responseSha1Result =
              hmacSha1.convert(keyValue.codeUnits);
          final responseHEncode64 = base64.encode(responseSha1Result.bytes);
          if (responseHEncode64 == h) {
            hOk = true;
          }
          if (!nonceOk || !otpOk || !hOk) {
            verificationResponse.status = 'RESPONSE_KO';
          }
        }
      }
    } catch (e) {
      verificationResponse.status = 'RESPONSE_KO';
    }
    return verificationResponse;
  }
}
