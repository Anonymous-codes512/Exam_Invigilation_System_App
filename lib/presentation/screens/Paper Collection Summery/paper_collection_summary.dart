import 'package:eis/core/constants/AppColors.dart';
import 'package:eis/core/constants/AppTheme.dart';
import 'package:eis/data/api/teacher_attendance.dart';
import 'package:eis/utils/loader_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // Import AwesomeDialog
import 'package:eis/data/controller/student_controller.dart';
import 'package:eis/data/controller/teacher_controller.dart';

class PaperCollectionScreen extends StatefulWidget {
  const PaperCollectionScreen({super.key});

  @override
  _PaperCollectionScreenState createState() => _PaperCollectionScreenState();
}

class _PaperCollectionScreenState extends State<PaperCollectionScreen> {
  // Controllers for student and teacher data
  final StudentController studentController = Get.find<StudentController>();
  final TeacherController teacherController = Get.find<TeacherController>();

  // List to hold papers from studentController
  List<String> papers = [];

  String? selectedPaper;
  int totalPapers = 0;
  int numberOfPapers = 0;
  String? collectorName;
  String? teacherNumber;
  String? teacherName;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Fetching teacher number from TeacherController
    teacherNumber = teacherController.teacherEmployeeNumber.value;
    teacherName = teacherController.teacherName.value;
    // Fetching papers from StudentController (using courseCode)
    setState(() {
      papers = studentController.studentList
          .map((student) => student['courseCode'] as String)
          .toSet()
          .toList();
    });

    print("Teacher Number: $teacherNumber");
    print("Papers List: $papers");
  }

  // Function to submit the form
  Future<void> submitForm() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        LoaderService.show(context,
            message: "Submitting paper collection summary...");

        // Prepare report data
        final reportData = {
          'teacherNumber': teacherNumber,
          'selectedPaper': selectedPaper,
          'totalPapers': totalPapers,
          'numberOfPapers': numberOfPapers,
          'collectorName': collectorName,
          'roomNumber': studentController.studentList[0]['roomNumber'],
        };

        // Simulating an API call (you should replace this with the actual API service)
        await submitPaperCollection(reportData);

        LoaderService.hide();

        // Show success dialog
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'Success!',
          desc: 'Paper Collection submitted successfully',
          btnOkOnPress: () {
            _formKey.currentState!.reset();
            setState(() {
              selectedPaper = null;
              totalPapers = 0;
              numberOfPapers = 0;
              collectorName = null;
            });
          },
          btnOkText: 'OK',
          btnOkColor: AppColors.primaryColor,
          headerAnimationLoop: false,
          dismissOnTouchOutside: false,
        ).show();
      } catch (e) {
        LoaderService.hide();

        // Show error dialog
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Error',
          desc: 'Failed to submit paper collection. Please try again.',
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white, // Change your color here
        ),
        title: Text(
          'Paper Collection',
          style:
              AppTheme.headingStyle.copyWith(color: AppColors.backgroundColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Teacher's Name (Readonly)
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Teacher\'s Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue: teacherName,
                              enabled: false, // Make it readonly
                              decoration: InputDecoration(
                                labelText: 'Teacher\'s Name',
                                labelStyle: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Paper Dropdown
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Paper',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: selectedPaper,
                              hint: const Text('Select Paper'),
                              onChanged: (value) =>
                                  setState(() => selectedPaper = value),
                              validator: (value) => value == null
                                  ? 'Please select a paper'
                                  : null,
                              items: papers
                                  .map((paper) => DropdownMenuItem(
                                      value: paper, child: Text(paper)))
                                  .toList(),
                              decoration: InputDecoration(
                                labelText: 'Paper',
                                labelStyle: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Total Papers Input
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Number of Papers',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  totalPapers = int.tryParse(value) ?? 0;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the total number of papers';
                                }
                                if (int.tryParse(value) == null ||
                                    int.parse(value) <= 0) {
                                  return 'Enter a valid number greater than 0';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Total Number of Papers',
                                labelStyle: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Collected Papers Input
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Number of Papers Collected',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  numberOfPapers = int.tryParse(value) ?? 0;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the number of papers collected';
                                }
                                final collected = int.tryParse(value);
                                if (collected == null || collected <= 0) {
                                  return 'Enter a valid number greater than 0';
                                }
                                if (collected > totalPapers) {
                                  return 'Collected papers cannot exceed total papers';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Number of Papers Collected',
                                labelStyle: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Collector's Name Input
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Collector\'s Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue: collectorName,
                              onSaved: (value) => collectorName = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                                  return 'Name can only contain alphabets and spaces';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Collector\'s Name',
                                labelStyle: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.send),
                            SizedBox(width: 10),
                            Text(
                              'Submit Collection',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
