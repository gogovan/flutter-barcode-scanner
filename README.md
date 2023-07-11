# flutter_barcode_scanner

A generic library for integrating Physical Barcode scanners. Supports scanners that uses external keyboard interface as their output.

# Device support

For iOS, this plugin requires iOS 14.0 or above.

This plugin should support all scanners that connect with Android/iOS devices as an external keyboard, and send received barcodes as keyboard entry. It could be connected by USB or bluetooth.

This plugin has been tested with Hanyin HPRT HI-320.

# Usage

1. Connect your scanner.
   1. For bluetooth scanners, refer to documentations for [Android](https://support.google.com/android/answer/9075925?hl=en#zippy=%2Coption-use-the-settings-app-all-bluetooth-accessories%2Cunpair-rename-or-pick-actions-for-a-bluetooth-accessory) and [iOS](https://support.apple.com/en-us/HT204091).
   2. If you cannot find your scanner, confirm that no other devices are currently connecting to your scanner.
2. Check your scanner is connected with `isScannerConnected()` function.
```dart
final _flutterBarcodeScannerPlugin = FlutterBarcodeScanner();
bool result = await _flutterBarcodeScannerPlugin.isScannerConnected();
if (result) {
  // Scanner connected.
}
```
3. Receive barcodes from `listenToBarcode()` function. This function returns a Dart stream, so you can `listen()` to it or use a `StreamBuilder`.
```dart
MaterialApp(
  home: Scaffold(
    appBar: AppBar(
      title: const Text('Plugin example app'),
    ),
    body: Center(
      child: StreamBuilder(
          stream: _flutterBarcodeScannerPlugin.listenToBarcode(),
          builder: (context, data) {
            return Text(data.data);
          },
        ),
    ),
  ),
);
```
4. When you are done with the barcode scanner, stop listening to the barcode stream with `unlistenBarcode()`.
```dart
await _flutterBarcodeScannerPlugin.unlistenBarcode();
```
