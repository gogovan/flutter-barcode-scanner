import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner_platform_interface.dart';
import 'package:rxdart/rxdart.dart';

class FlutterBarcodeScanner {
  static const _scannerCollectKeysDelay = 50; // Milliseconds.

  StreamController<String?>? _keyEventController;
  KeyEventCallback? _keyEventCallback;

  Future<bool> isScannerConnected() =>
      FlutterBarcodeScannerPlatform.instance.isKeyboardConnected();

  Stream<bool> getScannerConnectedStream() =>
      FlutterBarcodeScannerPlatform.instance.getKeyboardConnectedStream();

  Stream<String?> listenToBarcode() {
    _keyEventCallback ??= (event) {
      if (event is KeyDownEvent) {
        _keyEventController?.add(event.character);
      }

      return true;
    };

    var controller = _keyEventController;

    if (controller != null) {
      HardwareKeyboard.instance.removeHandler(_keyEventCallback!);
      unawaited(controller.close());
    }

    controller = StreamController<String?>();
    _keyEventController = controller;

    HardwareKeyboard.instance.addHandler(_keyEventCallback!);

    final stream = controller.stream.asBroadcastStream();

    return stream
        .buffer(
          stream.debounceTime(
            const Duration(milliseconds: _scannerCollectKeysDelay),
          ),
        )
        .map((event) => event.where((x) => x != null).join());
  }

  void unlistenKeyEvents() {
    unawaited(_keyEventController?.close());
  }
}
