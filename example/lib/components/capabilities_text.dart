import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yubidart/yubidart.dart';

class CapabilitiesText extends StatelessWidget {
  const CapabilitiesText({
    super.key,
    required this.yubikitPlugin,
  });
  final Yubidart yubikitPlugin;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: capabilitiesString(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text('With capabilities : ${snapshot.data}');
        }
        return const Text('Loading capabilities ...');
      },
    );
  }

  Future<String> capabilitiesString() async {
    try {
      final capabilities = await yubikitPlugin.connection.deviceCapabilities;
      return 'nfc : ${capabilities.nfc}, wired : ${capabilities.wired}';
    } on PlatformException {
      return 'Failed to get device capabilities';
    }
  }
}
