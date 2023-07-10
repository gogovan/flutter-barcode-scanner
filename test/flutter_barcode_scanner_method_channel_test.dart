import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MethodChannelFlutterBarcodeScanner platform = MethodChannelFlutterBarcodeScanner();
  const MethodChannel channel = MethodChannel('flutter_barcode_scanner');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async => '42');
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
