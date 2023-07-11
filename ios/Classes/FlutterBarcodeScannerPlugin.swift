import Flutter
import UIKit
import GameController

public class FlutterBarcodeScannerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    var keyboardConnectedObserver: NSObjectProtocol?
    var keyboardDisconnectedObserver: NSObjectProtocol?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "hk.gogovan.flutter_barcode_scanner", binaryMessenger: registrar.messenger())
        let instance = FlutterBarcodeScannerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
          
        let keyboardChannel = FlutterEventChannel(name: "hk.gogovan.flutter_barcode_scanner.keyboardConnected", binaryMessenger: registrar.messenger())
            keyboardChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "isKeyboardConnected") {
          result(GCKeyboard.coalesced != nil)
        } else {
          result(FlutterError(code: "1000", message: "Unknown method", details: nil))
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        keyboardConnectedObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.GCKeyboardDidConnect,
            object: nil,
            queue: nil,
            using: { (n: Notification) in
                events(true)
            }
        )
        
        keyboardDisconnectedObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.GCKeyboardDidDisconnect,
            object: nil,
            queue: nil,
            using: { (n: Notification) in
                events(false)
            }
        )
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        if let ob = keyboardConnectedObserver {
            NotificationCenter.default.removeObserver(ob)
        }
        if let ob = keyboardDisconnectedObserver {
            NotificationCenter.default.removeObserver(ob)
        }
        
        return nil
    }

}
