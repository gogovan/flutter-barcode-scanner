import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'flutter_barcode_scanner_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<HardwareKeyboard>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final keyboard = MockHardwareKeyboard();
  final scanner = FlutterBarcodeScanner.withMockComponents(keyboard);

  group('un/listenToBarcode', () {
    setUp(() {
      when(keyboard.addHandler(any)).thenAnswer((realInvocation) {
        final keyboardHandler = realInvocation.positionalArguments[0];
        keyboardHandler!.call(
          const KeyDownEvent(
            physicalKey: PhysicalKeyboardKey.keyG,
            logicalKey: LogicalKeyboardKey.keyG,
            character: 'G',
            timeStamp: Duration(milliseconds: 1),
          ),
        );
        keyboardHandler!.call(
          const KeyDownEvent(
            physicalKey: PhysicalKeyboardKey.digit1,
            logicalKey: LogicalKeyboardKey.digit1,
            character: '1',
            timeStamp: Duration(milliseconds: 1),
          ),
        );
      });
      when(keyboard.removeHandler(any)).thenAnswer((realInvocation) {
        // no-op
      });
    });

    test('receive barcode', () async {
      await expectLater(scanner.listenToBarcode(), emits('G1'));
      verify(keyboard.addHandler(any)).called(1);
      await scanner.unlistenBarcode();
      verify(keyboard.removeHandler(any)).called(1);
    });
  });
}
