import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:chkpnt/styles/styles.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  static const List<BarcodeFormat> acceptedFormats = [
    BarcodeFormat.ean13,
    BarcodeFormat.upcA,
  ];

  static String? acceptedBarcode(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value != null &&
          value.isNotEmpty &&
          acceptedFormats.contains(barcode.format)) {
        return value;
      }
    }
    return null;
  }

  @override
  State<BarcodeScannerScreen> createState() => BarcodeScannerScreenState();
}

class BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    formats: BarcodeScannerScreen.acceptedFormats,
  );

  bool _hasDetected = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> handleDetection(BarcodeCapture capture) async {
    if (_hasDetected) return;

    final barcode = BarcodeScannerScreen.acceptedBarcode(capture);
    if (barcode == null) return;

    _hasDetected = true;
    await _controller.stop();

    if (!mounted) return;
    Navigator.of(context).pop(barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BarcodeScannerStyles.backgroundColour,
      appBar: _buildAppBar(),
      body: _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: BarcodeScannerStyles.appBarBackgroundColour,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: BarcodeScannerStyles.appBarIconColour,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Scan Barcode',
        style: BarcodeScannerStyles.appBarTitleStyle,
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(controller: _controller, onDetect: handleDetection),
        _buildInstruction(),
      ],
    );
  }

  Widget _buildInstruction() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: BarcodeScannerStyles.instructionMargin,
        padding: BarcodeScannerStyles.instructionPadding,
        decoration: BarcodeScannerStyles.instructionDecoration,
        child: const Text(
          'Point the camera at the barcode on the game case.',
          textAlign: TextAlign.center,
          style: BarcodeScannerStyles.instructionTextStyle,
        ),
      ),
    );
  }
}
