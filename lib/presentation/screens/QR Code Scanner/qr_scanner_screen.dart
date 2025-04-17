import 'package:eis/presentation/screens/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:eis/data/api/teacher_attendance.dart';
import 'package:get/get.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool torchEnabled = false;
  bool _isProcessing = false; // 🛑 Block duplicate calls

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: [
          IconButton(
            icon: Icon(torchEnabled ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                torchEnabled = !torchEnabled;
              });
              cameraController.toggleTorch();
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (BarcodeCapture barcodeCapture) async {
          if (_isProcessing) return; // prevent duplicate
          _isProcessing = true;

          final String? code = barcodeCapture.barcodes.first.rawValue;

          if (code != null) {
            debugPrint('QR Code: $code');
            final teacherEmail = code;
            await markTeacherAttendance(teacherEmail);

            // Optional: wait a bit before allowing another scan
            await Future.delayed(Duration(seconds: 2));

            // Navigate to dashboard
            Get.to(() => const DashboardScreen());
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Scan Error'),
                content:
                    const Text('No valid QR code detected. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }

          _isProcessing = false; // ✅ Reset flag
        },
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
