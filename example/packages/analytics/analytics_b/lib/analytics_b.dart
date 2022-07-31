import 'package:analytics/analytics_platform_interface.dart';

class AnalyticsBPlugin extends AnalyticsPlatform {
  // this is used by Flutter to run initial code for your plugin
  static void registerWith() {
    print('kekl');
    AnalyticsPlatform.instance = AnalyticsBPlugin();
  }

  @override
  Future<String> getPlatformVersion() async {
    return 'AnalyticsBPlugin: 0.0.1';
  }
}
