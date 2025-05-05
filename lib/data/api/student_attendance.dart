import 'dart:convert';
import 'dart:io';
import 'package:eis/data/controller/teacher_controller.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:get/get.dart';

HttpClient customHttpClient = HttpClient()
  ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

final httpClient = IOClient(customHttpClient);

Future<Map<String, dynamic>> markStudentAttendance(
    String studentRegistrationNumber) async {
  final teacherController = Get.find<TeacherController>();

  final teacherEmployeeNumber = teacherController.teacherEmployeeNumber.value;

  // final url =
  //     Uri.parse("https://10.110.13.96:7035/api/student/attendance_by_qr_code");
  final url = Uri.parse(
      "https://192.168.100.12:7035/api/student/attendance_by_qr_code");

  try {
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'studentRegistrationNumber': studentRegistrationNumber,
        'teacherEmployeeNumber': teacherEmployeeNumber,
        'DateAndTime': DateTime.now().toIso8601String(),
        // 'DateAndTime': '20/04/2025 3:55:57 pm',
      }),
    );

    if (response.statusCode == 200) {
      return {"success": true, "message": "Attendance marked successfully"};
    } else {
      print("❌ Failed: ${response.body}");
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      return {"success": false, "message": responseBody["message"]};
    }
  } catch (e) {
    print("🚨 Error sending attendance: $e");
    return {"success": false, "message": "Error sending attendance"};
  }
}

Future<Map<String, dynamic>> fetchStudentsData(
    String teacherEmployeeNumber, String dateAndTime) async {
  final url = Uri.parse(
      'http://192.168.100.12:7035/api/student/attendance_by_room?teacherEmployeeNumber=$teacherEmployeeNumber&dateAndTime=$dateAndTime');

  try {
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 30)); // Increase the timeout

    if (response.statusCode == 200) {
      // Parse the response body into a Map
      Map<String, dynamic> responseBody = json.decode(response.body);
      return {
        "success": true,
        "data": responseBody,
      };
    } else {
      return {
        "success": false,
        "message": "Failed to load data from the server",
      };
    }
  } catch (e) {
    return {
      "success": false,
      "message": "Error occurred while fetching data: $e",
    };
  }
}

Future<Map<String, dynamic>> markStudentAttendanceByRoom(
    String teacherEmployeeNumber) async {
  // final url =
  //     Uri.parse("https://10.110.13.96:7035/api/student/attendance_by_qr_code");
  final url = Uri.parse(
      "https://192.168.100.12:7035/api/student/attendance_by_qr_code");

  try {
    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'teacherEmployeeNumber': teacherEmployeeNumber,
        'DateAndTime': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      return {"success": true, "message": "Attendance marked successfully"};
    } else {
      print("❌ Failed: ${response.body}");
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      return {"success": false, "message": responseBody["message"]};
    }
  } catch (e) {
    print("🚨 Error sending attendance: $e");
    return {"success": false, "message": "Error sending attendance"};
  }
}
