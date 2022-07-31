import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class AnalyticsPlatform extends PlatformInterface {
  /// Constructs a AnalyticsPlatform.
  AnalyticsPlatform() : super(token: _token);

  static final Object _token = Object();

  static AnalyticsPlatform? _instance;

  /// The default instance of [AnalyticsPlatform] to use.
  static AnalyticsPlatform get instance => _instance!;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AnalyticsPlatform] when
  /// they register themselves.
  static set instance(AnalyticsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
