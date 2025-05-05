import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

enum QRScanType { teacher, student }

class QRScannerWidget extends StatefulWidget {
  final QRScanType scanType;
  final Function(String) onScanSuccess;

  const QRScannerWidget({
    super.key,
    required this.scanType,
    required this.onScanSuccess,
  });

  @override
  _QRScannerWidgetState createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  final MobileScannerController _cameraController = MobileScannerController();
  bool _torchEnabled = false;
  bool _isScanning = false;
  bool _isLoading = false; // To manage the loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.scanType == QRScanType.teacher
              ? 'Teacher Attendance QR'
              : 'Student Attendance QR',
        ),
        actions: [
          IconButton(
            icon: Icon(_torchEnabled ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                _torchEnabled = !_torchEnabled;
              });
              _cameraController.toggleTorch();
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => _cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: _cameraController,
        onDetect: (BarcodeCapture barcodeCapture) async {
          if (_isScanning || _isLoading) return; // Prevent multiple scans

          _isScanning = true; // Lock scanning to prevent duplicates

          final String? code = barcodeCapture.barcodes.first.rawValue;

          if (code != null) {
            debugPrint('Scanned QR Code: $code');
            setState(() {
              _isLoading = true; // Show loading indicator
            });

            widget.onScanSuccess(code); // Trigger the API call

            setState(() {
              _isLoading = false; // Stop loading once done
            });
          } else {
            _showErrorDialog('Scan Error', 'No valid QR code detected.');
            _isScanning = false;
          }
        },
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: title,
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
