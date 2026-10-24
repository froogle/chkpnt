import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:chkpnt/screens/edit/widgets/barcode_scanner_screen.dart';
import 'package:chkpnt/styles/styles.dart';

const MethodChannel _scannerChannel = MethodChannel(
  'dev.steenbakker.mobile_scanner/scanner/method',
);

void _stubScannerChannel() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_scannerChannel, (call) async {
        if (call.method == 'state') return 1;
        return null;
      });
}

void _clearScannerChannel() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_scannerChannel, null);
}

BarcodeCapture _capture(String value, BarcodeFormat format) {
  return BarcodeCapture(barcodes: [Barcode(rawValue: value, format: format)]);
}

Future<List<String?>> _pumpScanner(WidgetTester tester) async {
  final popped = <String?>[];

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder:
            (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  popped.add(
                    await Navigator.of(context).push<String>(
                      MaterialPageRoute(
                        builder: (_) => const BarcodeScannerScreen(),
                      ),
                    ),
                  );
                },
                child: const Text('Open Scanner'),
              ),
            ),
      ),
    ),
  );

  await tester.tap(find.text('Open Scanner'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));

  return popped;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(_stubScannerChannel);
  tearDown(_clearScannerChannel);

  group('BarcodeScannerScreen.acceptedBarcode', () {
    test('accepts EAN-13 barcodes', () {
      expect(
        BarcodeScannerScreen.acceptedBarcode(
          _capture('5026555248082', BarcodeFormat.ean13),
        ),
        '5026555248082',
      );
    });

    test('accepts UPC-A barcodes', () {
      expect(
        BarcodeScannerScreen.acceptedBarcode(
          _capture('711719127451', BarcodeFormat.upcA),
        ),
        '711719127451',
      );
    });

    test('ignores other symbologies', () {
      expect(
        BarcodeScannerScreen.acceptedBarcode(
          _capture('https://example.com', BarcodeFormat.qrCode),
        ),
        isNull,
      );
      expect(
        BarcodeScannerScreen.acceptedBarcode(
          _capture('123456789', BarcodeFormat.code128),
        ),
        isNull,
      );
    });

    test('ignores a capture with no barcodes', () {
      expect(
        BarcodeScannerScreen.acceptedBarcode(const BarcodeCapture()),
        isNull,
      );
    });

    test('picks the accepted barcode out of a mixed capture', () {
      const capture = BarcodeCapture(
        barcodes: [
          Barcode(rawValue: 'ignored', format: BarcodeFormat.qrCode),
          Barcode(rawValue: '4012927064528', format: BarcodeFormat.ean13),
        ],
      );

      expect(BarcodeScannerScreen.acceptedBarcode(capture), '4012927064528');
    });
  });

  group('BarcodeScannerScreen', () {
    testWidgets('renders its chrome with explicit colours', (tester) async {
      await _pumpScanner(tester);

      expect(find.byType(BarcodeScannerScreen), findsOneWidget);
      expect(find.text('Scan Barcode'), findsOneWidget);
      expect(
        find.text('Point the camera at the barcode on the game case.'),
        findsOneWidget,
      );

      final scaffold = tester.widget<Scaffold>(
        find.descendant(
          of: find.byType(BarcodeScannerScreen),
          matching: find.byType(Scaffold),
        ),
      );
      expect(scaffold.backgroundColor, BarcodeScannerStyles.backgroundColour);

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(
        appBar.backgroundColor,
        BarcodeScannerStyles.appBarBackgroundColour,
      );

      final instruction = tester.widget<Text>(
        find.text('Point the camera at the barcode on the game case.'),
      );
      expect(instruction.style, BarcodeScannerStyles.instructionTextStyle);
    });

    testWidgets('only accepts EAN-13 and UPC-A formats', (tester) async {
      await _pumpScanner(tester);

      final scanner = tester.widget<MobileScanner>(find.byType(MobileScanner));
      expect(scanner.controller!.formats, [
        BarcodeFormat.ean13,
        BarcodeFormat.upcA,
      ]);
    });

    testWidgets('pops with the scanned barcode', (tester) async {
      final popped = await _pumpScanner(tester);

      final state = tester.state<BarcodeScannerScreenState>(
        find.byType(BarcodeScannerScreen),
      );
      await state.handleDetection(
        _capture('5026555248082', BarcodeFormat.ean13),
      );
      await tester.pumpAndSettle();

      expect(popped, ['5026555248082']);
    });

    testWidgets('repeated detections for one scan dismiss only once', (
      tester,
    ) async {
      final popped = await _pumpScanner(tester);

      final state = tester.state<BarcodeScannerScreenState>(
        find.byType(BarcodeScannerScreen),
      );
      await state.handleDetection(
        _capture('5026555248082', BarcodeFormat.ean13),
      );
      await state.handleDetection(
        _capture('5026555248082', BarcodeFormat.ean13),
      );
      await state.handleDetection(
        _capture('4012927064528', BarcodeFormat.ean13),
      );
      await tester.pumpAndSettle();

      expect(popped, ['5026555248082']);
      expect(find.byType(BarcodeScannerScreen), findsNothing);
    });

    testWidgets('an ignored symbology does not dismiss the scanner', (
      tester,
    ) async {
      final popped = await _pumpScanner(tester);

      final state = tester.state<BarcodeScannerScreenState>(
        find.byType(BarcodeScannerScreen),
      );
      await state.handleDetection(
        _capture('https://example.com', BarcodeFormat.qrCode),
      );
      await tester.pump();

      expect(popped, isEmpty);
      expect(find.byType(BarcodeScannerScreen), findsOneWidget);
    });
  });
}
