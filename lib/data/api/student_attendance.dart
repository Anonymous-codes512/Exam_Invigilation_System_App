import 'dart:convert';
import 'dart:io';
import 'package:eis/data/controller/student_controller.dart';
import 'package:eis/data/controller/teacher_controller.dart';
import 'package:http/io_client.dart';
import 'package:get/get.dart';

final basicURI = "https://192.168.100.12:7035/api/student";
// final basicURI = "https://10.110.13.96:7035/api/student";

HttpClient customHttpClient = HttpClient()
  ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

final httpClient = IOClient(customHttpClient);

Future<Map<String, dynamic>> markStudentAttendance(
    String studentRegistrationNumber) async {
  final teacherController = Get.find<TeacherController>();

  final teacherEmployeeNumber = teacherController.teacherEmployeeNumber.value;

  final url = Uri.parse("$basicURI/attendance_by_qr_code");

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
  final studentController = Get.find<StudentController>();
  print(
      "🔄 ⛔⛔⛔ Calling fetchStudentsData... ${studentController.studentList.length}");

  // Check if data is already available, return the cached data
  if (studentController.isDataAvailable(teacherEmployeeNumber)) {
    return {
      "success": true,
      "data": studentController.studentList,
    }; // Return cached data
  }

  // If data is not available, fetch from API
  print("🌐 Fetching student data from API...");
  final url = Uri.parse(
      "$basicURI/fetch_student_from_room?teacherEmployeeNumber=$teacherEmployeeNumber&dateAndTime=$dateAndTime");

  try {
    final response = await httpClient.get(
      url,
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 30));

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (responseBody['success'] == true && responseBody['data'] != null) {
        List<dynamic> rawStudents = responseBody['data'];
        List<Map<String, dynamic>> studentMaps =
            List<Map<String, dynamic>>.from(rawStudents);

        // Save the teacher data and student data in the controller
        studentController
            .saveTeacherData(teacherEmployeeNumber); // Save Teacher ID
        studentController.saveStudentData(studentMaps); // Save student data

        print("✅ Data fetched and saved successfully.");
        return {
          "success": true,
          "data": studentMaps, // Return fetched data
        };
      } else {
        print("❌ API success=false or no data");
        return {
          "success": false,
          "message": "No data available",
        };
      }
    } else {
      print("❌ Failed to fetch: ${response.body}");
      return {
        "success": false,
        "message": "Failed to fetch data from the server",
      };
    }
  } catch (e) {
    print("❌ Error occurred while fetching: $e");
    return {
      "success": false,
      "message": "Error: $e",
    };
  }
}

Future<void> submitAttendanceAndUpdate() async {
  final studentController = Get.find<StudentController>();

  // Update the `attendanceStatus` in the controller before making the API call
  for (var student in studentController.studentList) {
    if (student["attendanceStatus"] == null) {
      student["attendanceStatus"] = "Absent"; // Default to "Absent" if not set
    }
  }

  // Prepare the data to send to the backend
  List<Map<String, dynamic>> studentsToSubmit =
      studentController.studentList.map((student) {
    return {
      "teacherEmployeeNumber": studentController
          .teacherId.value, // Teacher Employee Number from controller
      "registrationNumber":
          student["registrationNumber"], // Registration Number
      "roomNumber": student["roomNumber"], // Room Number
      "paperId": student["paperId"], // Paper ID
      "date": student["date"], // Date
      "timeSlot": student["timeSlot"], // Time Slot
      "attendanceStatus": student["attendanceStatus"], // Attendance Status
    };
  }).toList();

  try {
    final url = Uri.parse("$basicURI/submit-attendance-batch");

    for (var student in studentsToSubmit) {
      print("Student: $student");
    }

    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"students": studentsToSubmit}),
    );

    if (response.statusCode == 200) {
      // If the API call is successful, print the success message
      final responseBody = jsonDecode(response.body);

      if (responseBody["success"]) {
        print("✅ Attendance submitted successfully!");
      } else {
        print("❌ Failed to submit attendance: ${responseBody["message"]}");
      }
    } else {
      print(
          "❌ Failed to submit attendance. Server responded with status: ${response.statusCode}");
    }
  } catch (e) {
    print("🚨 Error occurred while submitting attendance: $e");
  }
}
