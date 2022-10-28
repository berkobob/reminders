#import "RemindersPlugin.h"
#if __has_include(<reminders/reminders-Swift.h>)
#import <reminders/reminders-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "reminders-Swift.h"
#endif

@implementation RemindersPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRemindersPlugin registerWithRegistrar:registrar];
}
@end
