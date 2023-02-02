#import "YubikitIosPlugin.h"
#if __has_include(<yubidart/yubidart-Swift.h>)
#import <yubidart/yubidart-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "yubidart-Swift.h"
#endif

@implementation YubikitIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYubikitIosPlugin registerWithRegistrar:registrar];
}
@end
