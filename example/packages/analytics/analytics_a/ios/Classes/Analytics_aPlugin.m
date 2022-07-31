#import "Analytics_aPlugin.h"
#if __has_include(<analytics_a/analytics_a-Swift.h>)
#import <analytics_a/analytics_a-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "analytics_a-Swift.h"
#endif

@implementation Analytics_aPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAnalytics_aPlugin registerWithRegistrar:registrar];
}
@end
