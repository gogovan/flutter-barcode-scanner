import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner_platform_interface.dart';

/// An implementation of [FlutterBarcodeScannerPlatform] that uses method channels.
class MethodChannelFlutterBarcodeScanner extends FlutterBarcodeScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('hk.gogovan.flutter_barcode_scanner');

  final _keyboardConnectedChannel = const EventChannel(
    'hk.gogovan.flutter_barcode_scanner.keyboardConnected',
  );

  @override
  Future<bool> isKeyboardConnected() async =>
      await methodChannel.invokeMethod<bool>('isKeyboardConnected') ?? false;

  @override
  Stream<bool> getKeyboardConnectedStream() =>
      _keyboardConnectedChannel.receiveBroadcastStream().cast();
}
