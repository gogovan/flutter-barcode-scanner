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

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String kbConnected;
    try {
      bool result =
          await _flutterBarcodeScannerPlugin.isKeyboardConnected() ?? false;
      kbConnected = 'Keyboard connected (at init) = $result';
    } on PlatformException {
      kbConnected = 'Failed to get result (at init)';
    }

    if (!mounted) return;

    setState(() {
      _kbConnectedText = kbConnected;
    });
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
              stream: _flutterBarcodeScannerPlugin.getKeyboardConnectedStream(),
              builder: (context, data) => Text('Keyboard connected = ${data.data}'),
            ),
          ],
        ),
      ),
    );
  }
}
