import 'package:eis/presentation/widgets/overlay_loader.dart';
import 'package:eis/presentation/widgets/qr_scanner_overlay.dart';
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
  MobileScannerController _cameraController = MobileScannerController();
  bool _torchEnabled = false;
  bool _isScanning = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cameraController = MobileScannerController();
    _resetState();
  }

  @override
  void didUpdateWidget(QRScannerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scanType != widget.scanType) {
      _resetState();
    }
  }

  void _resetState() {
    _isScanning = false;
    _isLoading = false;
    _torchEnabled = false;
  }

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
      body: OverlayLoader(
        isLoading: _isLoading,
        message: widget.scanType == QRScanType.teacher
            ? 'Processing teacher attendance...'
            : 'Processing student attendance...',
        child: Stack(
          children: [
            MobileScanner(
              controller: _cameraController,
              onDetect: (BarcodeCapture barcodeCapture) async {
                if (_isScanning || _isLoading) return;

                _isScanning = true;
                await Future.delayed(Duration(milliseconds: 500)); // Debounce
                final String? code = barcodeCapture.barcodes.first.rawValue;

                if (code != null) {
                  debugPrint('Scanned QR Code: $code');
                  setState(() {
                    _isLoading = true; // Show loading indicator
                  });

                  print(
                      '🔄 Initializing QRScannerWidget with type: ${widget.scanType}');
                  try {
                    // Log for debugging
                    print('✅ Widget scan type: ${widget.scanType}');
                    if (widget.scanType == QRScanType.student) {
                      // Call student API if the scan type is student
                      await widget
                          .onScanSuccess(code); // Pass code to student API
                    } else if (widget.scanType == QRScanType.teacher) {
                      // Call teacher API if the scan type is teacher
                      await widget
                          .onScanSuccess(code); // Pass code to teacher API
                    }
                  } catch (e) {
                    _showErrorDialog('Error', 'Failed to process QR code: $e');
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                        _isScanning =
                            false; // Unlock scanning after one successful scan
                      });
                    }
                  }
                } else {
                  _showErrorDialog('Scan Error', 'No valid QR code detected.');
                  _isScanning = false;
                }
              },
            ),
            QRScannerOverlay(
              scanType: widget.scanType,
            ),
          ],
        ),
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
