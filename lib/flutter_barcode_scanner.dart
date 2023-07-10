import 'package:flutter_barcode_scanner/flutter_barcode_scanner_platform_interface.dart';

class FlutterBarcodeScanner {
  Future<String?> getPlatformVersion() => FlutterBarcodeScannerPlatform.instance.getPlatformVersion();
}
