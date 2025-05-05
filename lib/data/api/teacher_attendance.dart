import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

HttpClient customHttpClient = HttpClient()
  ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

final httpClient = IOClient(customHttpClient);

Future<Map<String, dynamic>> markTeacherAttendance(
    String teacherEmployeeNumber) async {
  print("Mark Teacher Attendance Called");
  final url = Uri.parse(
      "https://192.168.100.12:7035/api/teacher/attendance_with_login");
  // final url =
  //     Uri.parse("https://10.110.13.96:7035/api/teacher/attendance_with_login");

  try {
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'teacherEmployeeNumber': teacherEmployeeNumber}),
    );

    if (response.statusCode == 200) {
      // If the response is successful, decode the response and return the teacher details
      final responseData = jsonDecode(response.body);
      print("✅ Attendance marked successfully\n${response.body}");

      return {
        "success": true,
        "teacherEmployeeNumber": responseData['teacherEmployeeNumber'],
        "teacherName": responseData['teacherName'],
        "teacherEmail": responseData['teacherEmail'],
        "teacherDesignation": responseData['teacherDesignation'],
        "teacherDepartment": responseData['teacherDepartment'],
      };
    } else {
      // If the request fails, return false and the message
      print("❌ Failed to mark attendance: ${response.body}");
      return {"success": false, "message": "Failed to mark attendance"};
    }
  } catch (e) {
    // If there's an error, return false with the error message
    print("🚨 Error sending attendance: $e");
    return {"success": false, "message": "Error sending attendance"};
  }
}
