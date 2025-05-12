import 'package:eis/data/controller/student_controller.dart';
import 'package:eis/data/controller/teacher_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eis/presentation/screens/splash/splashScreen.dart';

void main() {
  Get.put(StudentController()); // Register StudentController
  Get.put(TeacherController()); // Register TeacherController

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CUI WAH Exam Invigilation System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}
