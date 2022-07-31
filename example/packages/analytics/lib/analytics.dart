import 'analytics_platform_interface.dart';

class Analytics {
  Future<String> getPlatformVersion() {
    return AnalyticsPlatform.instance.getPlatformVersion();
  }
}
