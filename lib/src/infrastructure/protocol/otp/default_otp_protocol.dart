import 'package:nfc_manager/nfc_manager.dart';
import 'package:yubidart/src/domain/model/nfc/record.dart';
import 'package:yubidart/src/domain/model/nfc/wellknown_uri_record.dart';
import 'package:yubidart/src/domain/model/otp/verification_response.dart';
import 'package:yubidart/src/domain/protocol/otp/otp.dart';
import 'package:yubidart/src/infrastructure/protocol/otp/yubicloud_client.dart';

class DefaultOTPProtocol implements OTPProtocol {
  final YubicloudClient yubicloudClient;

  const DefaultOTPProtocol({
    required this.yubicloudClient,
  });

  @override
  String getOTPFromYubiKeyNFC(NfcTag tag) {
    final Ndef? tech = Ndef.from(tag);
    final NdefMessage? cachedMessage = tech!.cachedMessage;
    String otp = '';
    if (cachedMessage != null) {
      for (int i in Iterable<int>.generate(cachedMessage.records.length)) {
        final NdefRecord ndefRecord = cachedMessage.records[i];
        final record = Record.fromNdef(ndefRecord);
        if (record is WellknownUriRecord) {
          otp = '${record.uri}';
          otp = otp.split('#')[1];
        }
      }
    }
    return otp;
  }

  @override
  Future<OTPVerificationResponse> verifyOTPFromYubiKeyNFC(
    NfcTag tag,
    String apiKey,
    String id, {
    int? timeout,
    String? sl,
    String? timestamp,
  }) async {
    OTPVerificationResponse verificationResponse = OTPVerificationResponse();
    final String otp = getOTPFromYubiKeyNFC(tag);
    if (otp.isNotEmpty) {
      verificationResponse = await verify(
        otp,
        apiKey,
        id,
        timeout: timeout,
        sl: sl,
        timestamp: timestamp,
      );
    } else {
      verificationResponse.status = 'OTP_NOT_FOUND';
    }
    return verificationResponse;
  }

  @override
  Future<OTPVerificationResponse> verify(
    String otp,
    String apiKey,
    String id, {
    int? timeout,
    String? sl,
    String? timestamp,
  }) =>
      yubicloudClient.verify(
        otp: otp,
        apiKey: apiKey,
        id: id,
        sl: sl,
        timeout: timeout,
        timestamp: timestamp,
      );
}
