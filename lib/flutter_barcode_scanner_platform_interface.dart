import 'package:flutter_barcode_scanner/flutter_barcode_scanner_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterBarcodeScannerPlatform extends PlatformInterface {
  /// Constructs a FlutterBarcodeScannerPlatform.
  FlutterBarcodeScannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterBarcodeScannerPlatform _instance =
      MethodChannelFlutterBarcodeScanner();

  /// The default instance of [FlutterBarcodeScannerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterBarcodeScanner].
  static FlutterBarcodeScannerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterBarcodeScannerPlatform] when
  /// they register themselves.
  static set instance(FlutterBarcodeScannerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> isKeyboardConnected() {
    throw UnimplementedError('isKeyboardConnected() has not been implemented.');
  }
}
