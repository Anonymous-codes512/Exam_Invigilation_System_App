import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

HttpClient customHttpClient = HttpClient()
  ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

final httpClient = IOClient(customHttpClient);

Future<void> markTeacherAttendance(String teacherEmployeeNumber) async {
  final url = Uri.parse(
      "https://192.168.100.12:7035/api/teacher/attendance_with_login");

  try {
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'teacherEmployeeNumber': teacherEmployeeNumber,
        'scannedAt': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      print("✅ Attendance marked successfully\n${response.body}");
      print('Name = ${jsonDecode(response.body)['teacherName']}');
      print('Email = ${jsonDecode(response.body)['teacherEmail']}');
    } else {
      print(
          "❌ Failed to mark attendance: ${jsonDecode(response.body)['error']}");
    }
  } catch (e) {
    print("🚨 Error sending attendance: $e");
  }
}
