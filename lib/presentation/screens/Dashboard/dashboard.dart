import 'package:eis/core/constants/AppColors.dart';
import 'package:eis/core/constants/AppTheme.dart';
import 'package:eis/presentation/screens/Student%20Attendance%20By%20QR/student_attendance.dart';
import 'package:eis/presentation/screens/Paper%20Collection%20Summery/paper_collection_summary.dart';
import 'package:eis/presentation/screens/Profile/profile.dart';
import 'package:eis/presentation/screens/Room%20Based%20Attendance/room_based_attendance.dart';
import 'package:eis/presentation/screens/Unfair%20Means%20Reporting/unfair_means_report.dart';
import 'package:eis/presentation/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eis/data/controller/teacher_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var height = 0.0, width = 0.0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // Get teacher name from the TeacherController
    final teacherController = Get.find<TeacherController>();
    final teacherName = teacherController.teacherName;
    final teacherEmployeeNumber = teacherController.teacherEmployeeNumber.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Dashboard',
          style:
              AppTheme.headingStyle.copyWith(color: AppColors.backgroundColor),
        ),
        centerTitle: true,
        actions: [
          // Profile Icon
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: AppColors.backgroundColor,
              size: 50,
            ),
            onPressed: () {
              // Navigate to the Profile Page
              Get.to(() => const ProfilePage());
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
        ),
        child: Column(
          children: [
            // Welcome Text at the Top with Teacher's Name
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
              ),
              height: height * 0.10,
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Welcome, $teacherName', // Display teacher's name here
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                ),
                child: ListView(
                  children: [
                    // QR Scanner Button
                    DashboardCard(
                      icon: Icons.qr_code_scanner,
                      label: 'Student Attendance by QR',
                      onTap: () {
                        Get.off(() =>
                            StudentQRScannerScreen()); // Using off() to remove previous screens
                      },
                    ),

                    // Attendance by Room Button
                    DashboardCard(
                      icon: Icons.meeting_room,
                      label: 'Attendance by Room',
                      onTap: () {
                        Get.to(() => RoomBasedAttendance(
                              teacherEmployeeNumber: teacherEmployeeNumber,
                            ));
                      },
                    ),

                    // Collect Papers Button
                    DashboardCard(
                      icon: Icons.assignment_turned_in,
                      label: 'Collect Papers',
                      onTap: () {
                        Get.to(() => const PaperCollectionScreen());
                      },
                    ),

                    // Report Unfair Means Button
                    DashboardCard(
                      icon: Icons.report,
                      label: 'Report Unfair Means',
                      onTap: () {
                        Get.to(() => const UnfairMeansReportScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
