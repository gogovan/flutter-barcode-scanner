import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _kbConnectedText = 'Unknown';

  final _flutterBarcodeScannerPlugin = FlutterBarcodeScanner();
  Stream<String>? _barcodeStream;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String kbConnected;
    try {
      bool result =
          await _flutterBarcodeScannerPlugin.isScannerConnected() ?? false;
      kbConnected = 'Keyboard connected (at init) = $result';

      if (result) {
        _barcodeStream = _flutterBarcodeScannerPlugin.listenToBarcode();
      }
    } on PlatformException {
      kbConnected = 'Failed to get result (at init)';
    }

    if (!mounted) return;

    setState(() {
      _kbConnectedText = kbConnected;
    });
  }

  @override
  void dispose() async {
    await _flutterBarcodeScannerPlugin.unlistenBarcode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Text('$_kbConnectedText\n'),
            StreamBuilder(
              stream: _flutterBarcodeScannerPlugin.getScannerConnectedStream(),
              builder: (context, data) {
                _barcodeStream = _flutterBarcodeScannerPlugin.listenToBarcode();
                return Text('Keyboard connected = ${data.data}');
              },
            ),
            StreamBuilder(
              stream: _barcodeStream,
              builder: (context, data) {
                return Text(data.data ?? 'null');
              },
            ),
            ElevatedButton(
                onPressed: () => setState(() {}), child: Text('Refresh')),
          ],
        ),
      ),
    );
  }
}
