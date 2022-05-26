#import "AccSensorPlugin.h"
#if __has_include(<acc_sensor/acc_sensor-Swift.h>)
#import <acc_sensor/acc_sensor-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "acc_sensor-Swift.h"
#endif

@implementation AccSensorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAccSensorPlugin registerWithRegistrar:registrar];
}
@end
