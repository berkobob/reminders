import Flutter

public class SwiftRemindersPlugin: NSObject, FlutterPlugin {

  let reminders = Reminders()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "reminders", binaryMessenger: registrar.messenger())
    let instance = SwiftRemindersPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {

      case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)

      case "hasAccess":
        result(self.reminders.hasAccess)

      case "getDefaultList":
        result(self.reminders.getDefaultList())

      case "getAllLists":
        result(self.reminders.getAllLists())

      default:
        result(FlutterMethodNotImplemented)
    }
  }
}
