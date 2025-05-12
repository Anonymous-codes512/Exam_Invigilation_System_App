import 'package:get/get.dart';

class StudentController extends GetxController {
  var teacherId = ''.obs;
  var studentList = <Map<String, dynamic>>[].obs;

  // Save teacher data (Teacher ID)
  void saveTeacherData(String id) {
    teacherId.value = id;
  }

  // Save student data
  void saveStudentData(List<Map<String, dynamic>> students) {
    studentList.value = students;
  }

  // Method to check if student data is available for a specific teacher ID
  bool isDataAvailable(String teacherId) {
    // Check if the current teacherId matches the stored teacherId and that the list is not empty
    return this.teacherId.value == teacherId && studentList.isNotEmpty;
  }
}
