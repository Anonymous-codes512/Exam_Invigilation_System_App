import 'package:eis/core/constants/AppColors.dart';
import 'package:eis/core/constants/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:eis/data/model/student.dart';
import 'package:eis/data/api/student_attendance.dart'; // Assuming you have an API for fetching student data

class RoomBasedAttendance extends StatefulWidget {
  final String teacherEmployeeNumber;

  const RoomBasedAttendance({super.key, required this.teacherEmployeeNumber});

  @override
  _RoomBasedAttendanceState createState() => _RoomBasedAttendanceState();
}

class _RoomBasedAttendanceState extends State<RoomBasedAttendance> {
  var height = 0.0, width = 0.0;
  late List<Student> students; // List to store fetched student data
  bool showStudentList = false;

  // Function to fetch students' data from API
  Future<void> fetchData() async {
    String dateAndTime =
        DateTime.now().toIso8601String(); // Current date and time

    Map<String, dynamic> result =
        await fetchStudentsData(widget.teacherEmployeeNumber, dateAndTime);

    if (result["success"]) {
      // Parsing the student data into List<Student>
      List<Student> studentList = (result["data"] as List)
          .map((studentData) => Student.fromJson(studentData))
          .toList();

      setState(() {
        students = studentList;
        showStudentList = true; // Show the student list once data is fetched
      });
    } else {
      print("Failed to fetch data: ${result["message"]}");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the function to load student data when the page loads
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white, // Change your color here
        ),
        title: Text(
          'Room Based Attendance',
          style: AppTheme.headingStyle.copyWith(
            color: Colors.white, // Set the color to white
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Show message if no students found or data is still loading
            if (!showStudentList)
              Container(
                width: width,
                height: height * 0.82, // 80% of the screen height
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                ),
                child: Text(
                  'Loading student data...',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )
            else if (showStudentList)
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final student = students[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(student.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Seat No: ${student.seatNo}'),
                                    Text('Reg#: ${student.regNo}'),
                                    Text('Paper: ${student.paper}'),
                                    Text('Time Slot: ${student.timeSlot}'),
                                    Text(
                                        'Attendance Status: ${student.attendanceStatus}'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    student.attendanceStatus == 'Present'
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: student.attendanceStatus == 'Present'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  onPressed: () => toggleAttendance(index),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Toggle attendance status (Present/Absent)
  void toggleAttendance(int index) {
    setState(() {
      students[index].attendanceStatus =
          students[index].attendanceStatus == 'Absent' ? 'Present' : 'Absent';
    });
  }
}
