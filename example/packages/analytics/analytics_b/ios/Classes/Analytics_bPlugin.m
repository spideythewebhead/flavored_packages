#import "Analytics_bPlugin.h"
#if __has_include(<analytics_b/analytics_b-Swift.h>)
#import <analytics_b/analytics_b-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "analytics_b-Swift.h"
#endif

@implementation Analytics_bPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAnalytics_bPlugin registerWithRegistrar:registrar];
}
@end
