import 'package:flutter_barcode_scanner/flutter_barcode_scanner_platform_interface.dart';

class FlutterBarcodeScanner {
  Future<bool> isKeyboardConnected() =>
      FlutterBarcodeScannerPlatform.instance.isKeyboardConnected();

  Stream<bool> getKeyboardConnectedStream() =>
      FlutterBarcodeScannerPlatform.instance.getKeyboardConnectedStream();
}
