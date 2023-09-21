import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner_platform_interface.dart';
import 'package:rxdart/rxdart.dart';

class FlutterBarcodeScanner {
  FlutterBarcodeScanner() : _hardwareKeyboard = HardwareKeyboard.instance;

  @visibleForTesting
  FlutterBarcodeScanner.withMockComponents(this._hardwareKeyboard);

  StreamController<String?>? _keyEventController;
  KeyEventCallback? _keyEventCallback;

  final HardwareKeyboard _hardwareKeyboard;

  /// Check if a barcode scanner is currently connected.
  /// Currently it detects whether a Bluetooth keyboard is connected.
  Future<bool> isScannerConnected() =>
      FlutterBarcodeScannerPlatform.instance.isKeyboardConnected();

  /// Return a Stream which receives an event whenever the connection state of a barcode scanner changes.
  /// NOTE: As Android OS reloads the activity upon any changes to any physical keyboard, this function does not work properly on Android.
  /// Use isScannerConnected() on Android upon activity restart.
  Stream<bool> getScannerConnectedStream() =>
      FlutterBarcodeScannerPlatform.instance.getKeyboardConnectedStream();

  /// Listen to any barcodes received from the scanner.
  /// The returned stream receives an event containing the barcode after a barcode is scanned.
  ///
  /// Note that barcode scanning is not 100% accurate and you may need to do further checking on the received barcode.
  ///
  /// This collectKeyDelay parameter controls how long to wait for next key input from the barcode scanner until considering that the barcode has ended.
  /// It has a default duration of 100 milliseconds. If you find the received barcodes are consistently being cut short, try increasing this duration.
  ///
  /// Call unlistenToBarcode() once client no longer need to listen to barcodes.
  Stream<String> listenToBarcode({
    Duration collectKeyDelay = const Duration(
      milliseconds: 100,
    ),
  }) {
    _keyEventCallback ??= (event) {
      if (event is KeyDownEvent) {
        if (event.character != null) {
          _keyEventController?.add(event.character);
        }
      }

      return true;
    };

    var controller = _keyEventController;

    if (controller != null) {
      _hardwareKeyboard.removeHandler(_keyEventCallback!);
      unawaited(controller.close());
    }

    controller = StreamController<String>();
    _keyEventController = controller;

    _hardwareKeyboard.addHandler(_keyEventCallback!);

    final stream = controller.stream.asBroadcastStream();

    return stream
        .buffer(stream.debounceTime(collectKeyDelay))
        .map((event) => event.where((x) => x != null).join());
  }

  /// Stop listening to barcodes.
  Future<void> unlistenBarcode() async {
    final callback = _keyEventCallback;
    if (callback != null) {
      _hardwareKeyboard.removeHandler(callback);
    }

    // ignore: avoid-ignoring-return-values, not needed.
    await _keyEventController?.close();
  }
}
