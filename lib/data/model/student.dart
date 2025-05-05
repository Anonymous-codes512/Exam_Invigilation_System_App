class Student {
  final String name;
  final String seatNo;
  final String regNo;
  final String paper;
  final String timeSlot;
  String attendanceStatus;

  Student({
    required this.name,
    required this.seatNo,
    required this.regNo,
    required this.paper,
    required this.timeSlot,
    this.attendanceStatus = 'Absent', // Default to Absent
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'],
      seatNo: json['seatNo'],
      regNo: json['regNo'],
      paper: json['paper'],
      timeSlot: json['timeSlot'],
      attendanceStatus:
          json['attendanceStatus'] ?? 'Absent', // Default to 'Absent'
    );
  }
}
