import Flutter
import UIKit
import GameController

public class FlutterBarcodeScannerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_barcode_scanner", binaryMessenger: registrar.messenger())
    let instance = FlutterBarcodeScannerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if (call.method == "isKeyboardConnected") {
          if #available(iOS 14.0, *) {
              result(GCKeyboard.coalesced != nil)
          } else {
              result(false)
//              guard let userInfo = notification.userInfo else {
//                  result(FlutterError(code: "1001", message: "Unable to retrieve userInfo", details: nil))
//              }
//              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//              let keyboard = self.view.convert(keyboardScreenEndFrame, from: self.view.window)
//              let height = self.view.frame.size.height
//              if (keyboard.origin.y + keyboard.size.height) > height {
//                  result(true);
//              } else {
//                  result(false);
//              }
          }
      } else {
          result(FlutterError(code: "1000", message: "Unknown method", details: nil))
      }
  }
}
