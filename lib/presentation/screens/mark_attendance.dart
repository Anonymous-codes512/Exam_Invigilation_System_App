import 'package:flutter/material.dart';
import 'package:eis/data/model/student.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  // List of Pakistani student names
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

  // Declare students list, it will be initialized in initState
  late List<Student> students;

  // Filter variables
  String? selectedRoom;
  final List<String> roomNumbers = ['A1', 'B2', 'C3', 'D4'];

  bool showStudentList =
      false; // Flag to control visibility of the student list

  // Method to toggle attendance status
  void toggleAttendance(int index) {
    setState(() {
      students[index].attendanceStatus =
          students[index].attendanceStatus == 'Absent' ? 'Present' : 'Absent';
    });
  }

  @override
  void initState() {
    super.initState();

    // Initialize the students list after the widget is created
    students = List.generate(30, (index) {
      return Student(
        name:
            studentsNames[index % studentsNames.length], // Cycle through names
        seatNo: 'A${index + 1}',
        regNo:
            'FA21-BSE-${(index + 1).toString().padLeft(3, '0')}', // Format regNo with leading zeros
        paper: 'CSC461 ITSD',
        timeSlot: '9:00 AM - 11:00 AM',
        attendanceStatus: 'Absent',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Scrollable Filter Row with Dropdowns and Search Button
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
                    // Class (Room) filter dropdown with improved design
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(30),
                        // ),
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

            // Show student list only after search
            if (showStudentList)
              Expanded(
                child: ListView.builder(
                  itemCount: students.length, // Show all students
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
              ),
          ],
        ),
      ),
    );
  }
}
