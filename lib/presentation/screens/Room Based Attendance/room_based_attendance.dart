import 'package:eis/core/constants/AppColors.dart';
import 'package:eis/core/constants/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:eis/data/model/student.dart';

class RoomBasedAttendance extends StatefulWidget {
  const RoomBasedAttendance({super.key});

  @override
  _RoomBasedAttendanceState createState() => _RoomBasedAttendanceState();
}

class _RoomBasedAttendanceState extends State<RoomBasedAttendance> {
  var height = 0.0, width = 0.0;

  List<String> studentsNames = [
    'Ahmed',
    'Fatima',
    'Ali',
    'Sara',
    'Omar',
    'Ayesha',
    'Hassan',
    'Zainab',
    'Ibrahim',
    'Nida',
    'Usman',
    'Mariam',
    'Bilal',
    'Zain',
    'Kiran',
    'Hina',
    'Yasir',
    'Sana',
    'Rashid',
    'Shazia',
    'Imran',
    'Noor',
    'Tariq',
    'Amina',
    'Waseem',
    'Bushra',
    'Faizan',
    'Mehmood',
    'Khalid',
    'Rehan'
  ];

  late List<Student> students;

  String? selectedRoom;
  final List<String> roomNumbers = ['A1', 'B2', 'C3', 'D4'];

  bool showStudentList = false;

  void toggleAttendance(int index) {
    setState(() {
      students[index].attendanceStatus =
          students[index].attendanceStatus == 'Absent' ? 'Present' : 'Absent';
    });
  }

  @override
  void initState() {
    super.initState();

    students = List.generate(30, (index) {
      return Student(
        name: studentsNames[index % studentsNames.length],
        seatNo: 'A${index + 1}',
        regNo: 'FA21-BSE-${(index + 1).toString().padLeft(3, '0')}',
        paper: 'CSC461 ITSD',
        timeSlot: '9:00 AM - 11:00 AM',
        attendanceStatus: 'Absent',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
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
            // Room selection and search bar in a separate container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Class (Room) filter dropdown with 90% width
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            0.8, // 90% of screen width
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButton<String>(
                          value: selectedRoom,
                          hint: const Text('Select Room',
                              style: TextStyle(fontSize: 16)),
                          onChanged: (value) {
                            setState(() {
                              selectedRoom = value;
                            });
                          },
                          items: roomNumbers.map((room) {
                            return DropdownMenuItem(
                              value: room,
                              child: Row(
                                children: [
                                  Icon(Icons.meeting_room, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(room, style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            );
                          }).toList(),
                          underline: SizedBox(),
                          isExpanded: false,
                        ),
                      ),
                    ),

                    // Search button
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          showStudentList = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Show message if room is not selected
            if (selectedRoom == null)
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
                  'Please select a room to view the list.',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )
            else if (selectedRoom != null && showStudentList)
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
}
