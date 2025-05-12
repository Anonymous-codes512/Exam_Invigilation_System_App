import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:eis/data/api/student_attendance.dart';
import 'package:eis/data/controller/student_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eis/core/constants/AppColors.dart';
import 'package:eis/core/constants/AppTheme.dart';
import 'package:eis/utils/loader_service.dart';

class RoomBasedAttendance extends StatefulWidget {
  final String teacherEmployeeNumber;

  const RoomBasedAttendance({super.key, required this.teacherEmployeeNumber});

  @override
  _RoomBasedAttendanceState createState() => _RoomBasedAttendanceState();
}

class _RoomBasedAttendanceState extends State<RoomBasedAttendance> {
  var height = 0.0, width = 0.0;
  List<Map<String, dynamic>> students = [];
  bool showStudentList = false;
  bool isSubmitting = false;
  final StudentController studentController = Get.put(StudentController());

  // Function to fetch students' data from API
  Future<void> fetchData() async {
    print("🔄 Calling fetchStudentsData...");

    // Show loader
    LoaderService.show(context, message: "Fetching students in room...");

    // Fetch data from controller if available
    String dateAndTime = "2025-04-20T13:35:22.494506";
    Map<String, dynamic> result =
        await fetchStudentsData(widget.teacherEmployeeNumber, dateAndTime);

    LoaderService.hide(); // Hide loader

    if (result["success"]) {
      List<Map<String, dynamic>> studentList =
          List<Map<String, dynamic>>.from(result["data"]);
      setState(() {
        students = studentList;
        showStudentList = true;
      });

      studentController.saveTeacherData(widget.teacherEmployeeNumber);
      studentController.saveStudentData(studentList);
    } else {
      print("Failed to fetch data: ${result["message"]}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${result['message']}")),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData(); // Call fetchData safely *after* build is complete
    });
  }

  void toggleAttendance(int index) {
    setState(() {
      students[index]["attendanceStatus"] =
          students[index]["attendanceStatus"] == 'Present'
              ? 'Absent'
              : 'Present';
    });
  }

  Future<void> submitAttendance() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      LoaderService.show(context, message: "Submitting attendance...");

      await submitAttendanceAndUpdate();
      LoaderService.hide();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: 'Attendance submitted successfully.',
        btnOkOnPress: () {
          Get.back();
        },
        btnOkText: 'OK',
      ).show();
      // Navigate back after submission
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      LoaderService.hide();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: 'Failed to submit attendance.',
        btnOkOnPress: () {
          Get.back();
        },
        btnOkText: 'OK',
      ).show();
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        LoaderService.hide();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Room Based Attendance',
              style: AppTheme.headingStyle.copyWith(color: Colors.white)),
          centerTitle: true,
        ),
        body: Container(
          color: AppColors.primaryColor,
          child: Column(
            children: [
              const SizedBox(height: 16),
              if (!showStudentList)
                buildLoaderBox()
              else
                Expanded(child: buildStudentList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoaderBox() {
    return Container(
      width: width,
      height: height * 0.82,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      child: const Text(
        'Loading student data...',
        style: TextStyle(
            color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildStudentList() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(student["studentName"]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Seat No: ${student["seat"]}'),
                        Text('Reg#: ${student["registrationNumber"]}'),
                        Text('Paper: ${student["courseCode"]}'),
                        Text('Time Slot: ${student["timeSlot"]}'),
                        Text(
                            'Attendance Status: ${student["attendanceStatus"] ?? "Absent"}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        student["attendanceStatus"] == 'Present'
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: student["attendanceStatus"] == 'Present'
                            ? Colors.green
                            : Colors.red,
                      ),
                      onPressed: () => toggleAttendance(index),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: isSubmitting ? null : submitAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Submit Attendance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
