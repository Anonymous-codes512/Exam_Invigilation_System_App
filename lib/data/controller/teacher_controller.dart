import 'package:get/get.dart';

class TeacherController extends GetxController {
  // Observable variables to store teacher details
  var teacherName = ''.obs;
  var teacherEmail = ''.obs;
  var teacherDesignation = ''.obs;
  var teacherDepartment = ''.obs;

  // Method to save teacher data
  void saveTeacherData({
    required String name,
    required String email,
    required String designation,
    required String department,
  }) {
    teacherName.value = name;
    teacherEmail.value = email;
    teacherDesignation.value = designation;
    teacherDepartment.value = department;
  }

  // Method to clear teacher data
  void clearTeacherData() {
    teacherName.value = '';
    teacherEmail.value = '';
    teacherDesignation.value = '';
    teacherDepartment.value = '';
  }
}
