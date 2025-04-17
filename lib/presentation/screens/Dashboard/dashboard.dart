import 'package:eis/core/constants/AppColors.dart';
import 'package:eis/core/constants/AppTheme.dart';
import 'package:eis/presentation/screens/Profile/profile.dart';
import 'package:eis/presentation/screens/QR%20Code%20Scanner/qr_scanner_screen.dart';
import 'package:eis/presentation/screens/mark_attendance.dart';
import 'package:eis/presentation/screens/paper_collection_summary.dart';
import 'package:eis/presentation/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        // leading: ,
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
            // Welcome Text at the Top
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
              ),
              height: height * 0.10,
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Welcome, Teacher',
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
                      label: 'Attendance by QR',
                      onTap: () {
                        Get.to(() => const QRScannerScreen());
                      },
                    ),

                    // Attendance by Room Button
                    DashboardCard(
                      icon: Icons.meeting_room,
                      label: 'Attendance by Room',
                      onTap: () {
                        Get.to(() => const StudentListScreen());
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
                        // Implement functionality here
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

  // return Scaffold(
  //   appBar: AppBar(
  //     backgroundColor: AppColors.primaryColor.withOpacity(0.8),
  //     elevation: 0,
  //     leading: Builder(
  //       builder: (context) => IconButton(
  //         icon: const Icon(Icons.menu_rounded,
  //             color: AppColors.backgroundColor),
  //         onPressed: () => Scaffold.of(context).openDrawer(),
  //       ),
  //     ),
  //     title: Text(
  //       'Dashboard',
  //       style:
  //           AppTheme.headingStyle.copyWith(color: AppColors.backgroundColor),
  //     ),
  //     centerTitle: true,
  //     actions: [
  //       // Profile Icon
  //       IconButton(
  //         icon: const Icon(
  //           Icons.account_circle,
  //           color: AppColors.backgroundColor,
  //           size: 20,
  //         ),
  //         onPressed: () {
  //           // Navigate to the Profile Page
  //           Get.to(() => const ProfilePage());
  //         },
  //       ),
  //     ],
  //   ),
  //   body: Column(
  //     children: [
  //       // Welcome Text at the Top
  //       Container(
  //         padding: const EdgeInsets.all(16.0),
  //         color: AppColors.primaryColor.withOpacity(0.8),
  //         width: double.infinity,
  //         height: 125,
  //         child: Text(
  //           'Welcome, Teacher',
  //           style: TextStyle(
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //             color: AppColors.textColor,
  //           ),
  //         ),
  //       ),
  //       // Content Section (Grid View) below the Welcome Text
  //       Expanded(
  //         child: SingleChildScrollView(
  //           child: Container(
  //             padding: const EdgeInsets.all(16.0),
  //             decoration: BoxDecoration(
  //               color: AppColors.backgroundColor,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(20),
  //                 topRight: Radius.circular(20),
  //               ),
  //             ),
  //             child: GridView.count(
  //               shrinkWrap: true,
  //               physics:
  //                   NeverScrollableScrollPhysics(), // Disable GridView scrolling
  //               crossAxisCount: 2, // 2 cards in one row
  //               crossAxisSpacing: 16,
  //               mainAxisSpacing: 16,
  //               children: [
  //                 _buildDashboardCard(
  //                   icon: Icons.check_box,
  //                   color: Colors.blueAccent,
  //                   label: 'MCQS',
  //                   onTap: () {
  //                     // Navigate to MCQS screen
  //                   },
  //                 ),
  //                 _buildDashboardCard(
  //                   icon: Icons.quiz,
  //                   color: Colors.green,
  //                   label: 'QUIZ',
  //                   onTap: () {
  //                     // Navigate to Quiz screen
  //                   },
  //                 ),
  //                 _buildDashboardCard(
  //                   icon: Icons.assignment_turned_in,
  //                   color: Colors.orange,
  //                   label: 'Papers',
  //                   onTap: () {
  //                     // Navigate to Past Papers screen
  //                   },
  //                 ),
  //                 _buildDashboardCard(
  //                   icon: Icons.picture_as_pdf,
  //                   color: Colors.redAccent,
  //                   label: 'PDF',
  //                   onTap: () {
  //                     // Navigate to PDF screen
  //                   },
  //                 ),
  //                 _buildDashboardCard(
  //                   icon: Icons.work,
  //                   color: Colors.purple,
  //                   label: 'Jobs',
  //                   onTap: () {
  //                     // Navigate to Jobs screen
  //                   },
  //                 ),
  //                 _buildDashboardCard(
  //                   icon: Icons.info,
  //                   color: Colors.teal,
  //                   label: 'About Us',
  //                   onTap: () {
  //                     // Navigate to About Us screen
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   ),
  // );
  // }

  // Widget _buildDashboardCard({
  //   required IconData icon,
  //   required Color color,
  //   required String label,
  //   required Function onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: () => onTap(),
  //     child: Card(
  //       elevation: 8,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(20),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(0.3),
  //               blurRadius: 4,
  //               spreadRadius: 1,
  //             ),
  //           ],
  //         ),
  //         child: Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(icon, size: 60, color: color),
  //               SizedBox(height: 10),
  //               Text(
  //                 label,
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 16,
  //                   color: Colors.black,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

