import 'package:eis/core/constants/AppColors.dart';
import 'package:eis/presentation/widgets/education_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eis/data/controller/teacher_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TeacherController _teacherController = Get.find<TeacherController>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Teacher Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Container(
              color: Colors.white,
              child: const EducationLoader(
                message: 'Loading profile...',
              ),
            )
          : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    return Obx(() => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Avatar
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(_teacherController.teacherName.value),
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Teacher Name
                Text(
                  _teacherController.teacherName.value.isEmpty
                      ? 'No Name'
                      : _teacherController.teacherName.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Designation
                Text(
                  _teacherController.teacherDesignation.value.isEmpty
                      ? 'No Designation'
                      : _teacherController.teacherDesignation.value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // Information Cards
                _buildInfoCard(
                  title: 'Personal Information',
                  children: [
                    _buildInfoTile(
                      icon: Icons.badge,
                      label: 'Employee ID',
                      value: _teacherController.teacherEmployeeNumber.value,
                    ),
                    _buildInfoTile(
                      icon: Icons.email,
                      label: 'Email',
                      value: _teacherController.teacherEmail.value,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  title: 'Department Information',
                  children: [
                    _buildInfoTile(
                      icon: Icons.business,
                      label: 'Department',
                      value: _teacherController.teacherDepartment.value,
                    ),
                    _buildInfoTile(
                      icon: Icons.work,
                      label: 'Designation',
                      value: _teacherController.teacherDesignation.value,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildInfoCard(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue.shade700, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value.isEmpty ? 'Not available' : value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: value.isEmpty ? Colors.grey : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String fullName) {
    if (fullName.isEmpty) return '?';

    List<String> nameParts = fullName.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.length == 1 && nameParts[0].isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    } else {
      return '?';
    }
  }
}
