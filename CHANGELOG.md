Changelog
=========

#### Version 2.0.0-dev.1 (2023-XX-XX)
* Add PIV protocol
* BREAKING CHANGES :
  * `YubicoService().verifyYubiCloudOTP(otp, yubikeyClientAPIKey, yubikeyClientID);` becomes `Yubidart().otp.verify(otp, yubikeyClientAPIKey, yubikeyClientID);`
* TODO :
  * separate connection/authentication/processing actions

#### Version 1.0.4 (2022-08-16)
* h param is not good when we receive a '+'
* Update project (dependencies, lints, dart version)

#### Version 1.0.3 (2021-12-21)
* Add VerificationResponse object to manage the verification response from Yubicloud verifiy API

#### Version 1.0.2 (2021-12-19)
* Get OTP from NFC Yubikey (getOTPFromYubiKeyNFC method)
* Get OTP from NFC Yubikey and verify with yubiCloud (verifyOTPFromYubiKeyNFC method)

#### Version 1.0.1 (2021-12-18)
* Change description

#### Version 1.0.0 (2021-12-18)
* OTP protocol of yubikey with yubiCloud  