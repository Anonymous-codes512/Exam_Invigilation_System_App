import 'package:get/get.dart';

class TeacherController extends GetxController {
  // Observable variables to store teacher details
  var teacherEmployeeNumber = ''.obs;
  var teacherName = ''.obs;
  var teacherEmail = ''.obs;
  var teacherDesignation = ''.obs;
  var teacherDepartment = ''.obs;

  // Method to save teacher data
  void saveTeacherData({
    required String teacherEmployeeNumber,
    required String name,
    required String email,
    required String designation,
    required String department,
  }) {
    this.teacherEmployeeNumber.value = teacherEmployeeNumber;
    teacherName.value = name;
    teacherEmail.value = email;
    teacherDesignation.value = designation;
    teacherDepartment.value = department;
  }

  // Method to clear teacher data
  void clearTeacherData() {
    teacherEmployeeNumber.value = '';
    teacherName.value = '';
    teacherEmail.value = '';
    teacherDesignation.value = '';
    teacherDepartment.value = '';
  }
}
