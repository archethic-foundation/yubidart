import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:yubidart/src/domain/protocol/connection/protocol.dart';

abstract class YubidartPlatform extends PlatformInterface {
  /// Constructs a [YubidartPlatform].
  YubidartPlatform() : super(token: _token);

  static final Object _token = Object();

  static YubidartPlatform _instance = EmptyYubidartPlatformImplementation();

  /// The default instance of [YubidartPlatform] to use.
  ///
  /// Defaults to MethodChannelYubidart.
  static YubidartPlatform get instance => _instance;

  ConnectionProtocol get connection;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [YubidartPlatform] when
  /// they register themselves.
  static set instance(YubidartPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}

class EmptyYubidartPlatformImplementation implements YubidartPlatform {
  @override
  ConnectionProtocol get connection => throw UnimplementedError();
}
