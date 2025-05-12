import 'package:eis/presentation/screens/Dashboard/dashboard.dart';
import 'package:eis/presentation/widgets/qr_scanner_widget.dart';
import 'package:flutter/material.dart';
import 'package:eis/data/api/teacher_attendance.dart';
import 'package:eis/data/controller/teacher_controller.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class TeacherQRScannerScreen extends StatelessWidget {
  TeacherQRScannerScreen({super.key});
  final TeacherController teacherController = Get.put(TeacherController());

  @override
  Widget build(BuildContext context) {
    return QRScannerWidget(
      scanType: QRScanType.teacher,
      onScanSuccess: (code) async {
        final teacherEmail = code;

        // Call backend API to mark teacher attendance
        final response = await markTeacherAttendance(teacherEmail);

        if (response['success'] == true) {
          teacherController.saveTeacherData(
            teacherEmployeeNumber: response['teacherEmployeeNumber'] ?? '',
            name: response['teacherName'] ?? '',
            email: response['teacherEmail'] ?? '',
            designation: response['teacherDesignation'] ?? '',
            department: response['teacherDepartment'] ?? '',
          );
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
