import 'package:eis/presentation/screens/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:eis/data/api/teacher_attendance.dart';
import 'package:get/get.dart';
import 'package:eis/data/controller/teacher_controller.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool torchEnabled = false;
  bool isScanning = false; // Prevent multiple scans
  final TeacherController teacherController = Get.put(TeacherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: [
          // Torch Toggle Button
          IconButton(
            icon: Icon(torchEnabled ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                torchEnabled = !torchEnabled;
              });
              cameraController.toggleTorch();
            },
          ),
          // Switch Camera Button
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (BarcodeCapture barcodeCapture) async {
          if (isScanning) return; // Prevent multiple scans

          isScanning = true; // Lock scanning

          final String? code = barcodeCapture.barcodes.first.rawValue;

          if (code != null) {
            debugPrint('Scanned QR Code: $code');
            final teacherEmail = code;

            // Call backend API to mark attendance
            final response = await markTeacherAttendance(teacherEmail);

            if (response['success'] == true) {
              // Save teacher data to controller if attendance is marked
              teacherController.saveTeacherData(
                name: response['teacherName'],
                email: response['teacherEmail'],
                designation: response['teacherDesignation'],
                department: response['teacherDepartment'],
              );
              isScanning = false; // Unlock scanning before navigation
              // Get.toNamed('/dashboard');
              Get.to(() => const DashboardScreen());
            } else {
              // Show error dialog if backend response is not successful
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'Error',
                desc: response['message'] ??
                    'Failed to mark attendance. Please try again.',
                btnOkOnPress: () {},
              ).show().then((_) {
                isScanning = false; // Unlock scanning after dialog closes
              });
              return;
            }
          } else {
            // Show warning if QR code is invalid or not detected
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.bottomSlide,
              title: 'Scan Error',
              desc: 'No valid QR code detected. Please try again.',
              btnOkOnPress: () {},
            ).show().then((_) {
              isScanning = false; // Unlock scanning after dialog closes
            });
            return;
          }

          isScanning = false; // Unlock scanning if successful
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
