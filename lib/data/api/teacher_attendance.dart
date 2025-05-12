import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

final baseUri = "https://192.168.100.12:7035/api/teacher";
// final baseUri = "https://10.110.13.96:7035/api/teacher";

HttpClient customHttpClient = HttpClient()
  ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

final httpClient = IOClient(customHttpClient);

Future<Map<String, dynamic>> markTeacherAttendance(
    String teacherEmployeeNumber) async {
  print("Mark Teacher Attendance Called");
  final url = Uri.parse("$baseUri/attendance_with_login");

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

Future<Map<String, dynamic>> unfairMeansReportSubmit(
    Map<String, dynamic> reportData) async {
  try {
    print('🔁🔂🔁🔂 Report Data: $reportData');
    final Uri url = Uri.parse('$baseUri/unfair-means-report');
    final response = await httpClient
        .post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reportData),
    )
        .timeout(
      const Duration(seconds: 15), // Set a timeout
      onTimeout: () {
        throw Exception(
            'Connection timeout. Please check your internet connection and try again.');
      },
    );

    // Check if the request was successful
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Parse and return the response data
      return jsonDecode(response.body);
    } else {
      // Handle error responses
      final errorData = jsonDecode(response.body);
      throw Exception(
          errorData['message'] ?? 'Failed to submit report. Please try again.');
    }
  } catch (e) {
    // Handle exceptions
    throw Exception('Error submitting report: ${e.toString()}');
  }
}

Future<Map<String, dynamic>> submitPaperCollection(
    Map<String, dynamic> reportData) async {
  try {
    final Uri url = Uri.parse('$baseUri/paper-collection');
    // Send the POST request to the backend
    final response = await httpClient
        .post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reportData), // Send the report data in the request body
    )
        .timeout(
      const Duration(seconds: 15), // Set a timeout duration
      onTimeout: () {
        // Handle timeout error
        throw Exception(
            'Connection timeout. Please check your internet connection and try again.');
      },
    );

    // Check if the request was successful (status code 200-299)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Parse and return the response data
      return jsonDecode(response.body);
    } else {
      // Handle unsuccessful responses
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ??
          'Failed to submit paper collection. Please try again.');
    }
  } catch (e) {
    // Handle exceptions (e.g., network errors, timeout, etc.)
    throw Exception('Error submitting paper collection: ${e.toString()}');
  }
}
