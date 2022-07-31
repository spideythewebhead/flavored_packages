import 'package:analytics/analytics_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AnalyticsA extends AnalyticsPlatform {
  static void registerWith() {
    AnalyticsPlatform.instance = AnalyticsA();
  }

  @visibleForTesting
  final methodChannel = const MethodChannel('analytics');

  @override
  Future<String> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion') as String;
    return version;
  }
}
