// class Student {
//   final String name;
//   final String seatNo;
//   final String regNo;
//   final String paper;
//   final String timeSlot;
//   String attendanceStatus;

//   Student({
//     required this.name,
//     required this.seatNo,
//     required this.regNo,
//     required this.paper,
//     required this.timeSlot,
//     this.attendanceStatus = 'Absent', // Default to Absent
//   });

//   factory Student.fromJson(Map<String, dynamic> json) {
//     return Student(
//       name: json['name'],
//       seatNo: json['seatNo'],
//       regNo: json['regNo'],
//       paper: json['paper'],
//       timeSlot: json['timeSlot'],
//       attendanceStatus:
//           json['attendanceStatus'] ?? 'Absent', // Default to 'Absent'
//     );
//   }
// }


// {
//   "success":true,
//   "data":[
//     {
//       "studentName":"Faisal Ali",
//       "registrationNumber":"FA18-CE-145",
//       "seat":"A1",
//       "courseCode":"CSC-302",
//       "date":"2025-04-20",
//       "timeSlot":"1:00 PM - 2:30 PM",
//       "roomNumber":"F-5"
//       },
//     {
//       "studentName":"Asim Asim",
//       "registrationNumber":"FA19-CE-107",
//       "seat":"A2",
//       "courseCode":"CSC-302",
//       "date":"2025-04-20",
//       "timeSlot":"1:00 PM - 2:30 PM"
//       ,"roomNumber":"F-5"
//       },
//     {
//       "studentName":"Usman Usman",
//       "registrationNumber":"FA24-AF-119",
//       "seat":"A3",
//       "courseCode":"CSC-302",
//       "date":"2025-04-20",
//       "timeSlot":"1:00 PM - 2:30 PM"
//       ,"roomNumber":"F-5"
//       },
//     {
//       "studentName":"Imran Zain",
//       "registrationNumber":"SP20-AI-405",
//       "seat":"A4",
//       "courseCode":"CSC-302",
//       "date":"2025-04-20",
//       "timeSlot":"1:00 PM - 2:30 PM"
//       ,"roomNumber":"F-5"
//       },
//     {
//       "studentName":"Asim Raza",
//       "registrationNumber":"SP24-AI-368",
//       "seat":"A5",
//       "courseCode":"CSC-302",
//       "date":"2025-04-20",
//       "timeSlot":"1:00 PM - 2:30 PM"
//       ,"roomNumber":"F-5"
//       }
//     ]
//   }