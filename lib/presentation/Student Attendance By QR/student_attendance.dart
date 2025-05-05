import 'package:eis/presentation/screens/Dashboard/dashboard.dart';
import 'package:eis/presentation/widgets/qr_scanner_widget.dart';
import 'package:flutter/material.dart';
import 'package:eis/data/api/student_attendance.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class StudentQRScannerScreen extends StatelessWidget {
  const StudentQRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return QRScannerWidget(
      scanType: QRScanType.student,
      onScanSuccess: (code) async {
        final studentRegistrationNumber = code;

        // Call backend API to mark attendance
        final response = await markStudentAttendance(studentRegistrationNumber);

        if (response['success'] == true) {
          Get.to(() => const DashboardScreen());
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.bottomSlide,
            title: 'Error',
            desc: response['message'] ?? 'Failed to mark attendance.',
            btnOkOnPress: () {},
          ).show();
        }
      },
    );
  }
}
