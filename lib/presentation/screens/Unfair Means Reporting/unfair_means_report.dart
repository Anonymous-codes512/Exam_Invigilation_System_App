import 'package:eis/core/constants/AppColors.dart';
import 'package:eis/data/api/teacher_attendance.dart';
import 'package:eis/data/controller/student_controller.dart';
import 'package:eis/data/controller/teacher_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For GetX state management
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:eis/utils/loader_service.dart'; // Import the loader service used throughout the app

class UnfairMeansReportScreen extends StatefulWidget {
  const UnfairMeansReportScreen({super.key});

  @override
  _UnfairMeansReportScreenState createState() =>
      _UnfairMeansReportScreenState();
}

class _UnfairMeansReportScreenState extends State<UnfairMeansReportScreen> {
  final teacherController =
      Get.find<TeacherController>(); // TeacherController to manage teacher data
  final studentController =
      Get.find<StudentController>(); // StudentController to manage student data

  String? teacherNumber;
  String? selectedPaper;
  String? studentRegistration;
  DateTime? selectedDate = DateTime.now(); // Initialize with current date
  String? unfairType;
  String? otherUnfairType;
  String? incidentDetails;
  String? roomNumber;

  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    teacherNumber = teacherController.teacherEmployeeNumber.value;
    roomNumber = studentController.studentList.isNotEmpty
        ? studentController.studentList[0]['roomNumber']
        : '';
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        LoaderService.show(context, message: "Submitting report...");

        // Prepare report data
        final reportData = {
          'studentRegistration': studentRegistration,
          'teacherEmployeeNumber': teacherNumber,
          'courseCode': selectedPaper,
          'date': selectedDate?.toIso8601String(),
          'unfairType': unfairType,
          'otherDetails': unfairType == 'Other' ? otherUnfairType : '',
          'incidentDetails': incidentDetails,
          'roomNumber': roomNumber, // Added room number in the report
        };

        // Call API service (commented out as an example)
        await unfairMeansReportSubmit(reportData);

        LoaderService.hide();

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'Success!',
          desc: 'Unfair Means Report submitted successfully',
          btnOkOnPress: () {
            _formKey.currentState!.reset();
            setState(() {
              selectedPaper = null;
              selectedDate = DateTime.now();
              unfairType = null;
              otherUnfairType = null;
              incidentDetails = null;
              roomNumber = ''; // Reset room number after submission
            });
          },
          btnOkText: 'OK',
          btnOkColor: AppColors.primaryColor,
          headerAnimationLoop: false,
          dismissOnTouchOutside: false,
        ).show();
      } catch (e) {
        LoaderService.hide();

        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Error',
          desc: 'Failed to submit report. Please try again.',
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        LoaderService.hide();
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.primaryColor,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            title: const Text(
              'Unfair Means Report',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Student Registration Dropdown (fetching from studentController)
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
                                'Student Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: studentRegistration,
                                hint: const Text('Select Student Registration'),
                                onChanged: (value) {
                                  setState(() {
                                    studentRegistration = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select a student'
                                    : null,
                                items: studentController.studentList
                                    .map((student) => DropdownMenuItem<String>(
                                          value: student['registrationNumber']
                                              as String,
                                          child: Text(
                                              "${student['studentName']} - ${student['registrationNumber']}"),
                                        ))
                                    .toList(),
                                decoration: InputDecoration(
                                  labelText: 'Student Registration',
                                  prefixIcon: const Icon(Icons.person,
                                      color: AppColors.primaryColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Teacher Number (Non-editable)
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
                                'Teacher Number',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                initialValue: teacherNumber,
                                enabled: false, // Make it non-editable
                                decoration: InputDecoration(
                                  labelText: 'Teacher Number',
                                  prefixIcon: const Icon(Icons.school,
                                      color: AppColors.primaryColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Room Number (Read-only)
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
                                'Room Number',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                initialValue: roomNumber ?? '',
                                enabled:
                                    false, // Make it non-editable (read-only)
                                decoration: InputDecoration(
                                  labelText: 'Room Number',
                                  prefixIcon: const Icon(Icons.room,
                                      color: AppColors.primaryColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Paper Dropdown (fetching distinct papers from studentController)
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
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaper = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select a paper'
                                    : null,
                                items: studentController.studentList
                                    .map((student) => student['courseCode'])
                                    .toSet()
                                    .map((courseCode) =>
                                        DropdownMenuItem<String>(
                                          value: courseCode,
                                          child: Text(courseCode),
                                        ))
                                    .toList(),
                                decoration: InputDecoration(
                                  labelText: 'Paper',
                                  prefixIcon: const Icon(Icons.book,
                                      color: AppColors.primaryColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Unfair Means Type Dropdown
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
                                'Type of Unfair Means',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: unfairType,
                                hint: const Text('Select Unfair Type'),
                                onChanged: (value) {
                                  setState(() {
                                    unfairType = value;
                                    if (unfairType != 'Other') {
                                      otherUnfairType =
                                          null; // Reset "Other" details if not selected
                                    }
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select an unfair type'
                                    : null,
                                items: [
                                  'Cheating Material',
                                  'Answer Sheet',
                                  'Mobile Phone',
                                  'Electronic Gadget',
                                  'Electronic Spell Checker',
                                  'Other'
                                ]
                                    .map((type) => DropdownMenuItem<String>(
                                          value: type,
                                          child: Text(type),
                                        ))
                                    .toList(),
                                decoration: InputDecoration(
                                  labelText: 'Unfair Type',
                                  prefixIcon: const Icon(Icons.error,
                                      color: AppColors.primaryColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (unfairType == 'Other')
                                TextFormField(
                                  initialValue: otherUnfairType,
                                  onChanged: (value) {
                                    setState(() {
                                      otherUnfairType = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Specify Other Unfair Type',
                                    prefixIcon: const Icon(Icons.text_fields,
                                        color: AppColors.primaryColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: AppColors.primaryColor,
                                          width: 2),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      // Incident Details TextField
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
                                'Incident Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                maxLines: 4,
                                onChanged: (value) {
                                  setState(() {
                                    incidentDetails = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Describe the incident',
                                  prefixIcon: const Icon(Icons.description,
                                      color: AppColors.primaryColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Submit Button
                      const SizedBox(height: 20),
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
                                'Submit Report',
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
      ),
    );
  }
}
