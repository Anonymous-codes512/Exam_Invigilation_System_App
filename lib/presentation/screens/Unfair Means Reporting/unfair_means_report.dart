import 'package:eis/core/constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // Import AwesomeDialog

class UnfairMeansReportScreen extends StatefulWidget {
  const UnfairMeansReportScreen({super.key});

  @override
  _UnfairMeansReportScreenState createState() =>
      _UnfairMeansReportScreenState();
}

class _UnfairMeansReportScreenState extends State<UnfairMeansReportScreen> {
  final List<String> papers = [
    'CSC496 DWH & DM',
    'CSC461 ITDS',
    'CSC475 NC',
    'CSE498 SDP',
    'CSE455 ST',
  ];

  String? selectedPaper;
  String? studentRegistration;
  String? teacherNumber;
  DateTime? selectedDate;
  String? unfairType;
  String? otherUnfairType;
  final _formKey = GlobalKey<FormState>();

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: 'Unfair Means Report Submitted',
        desc:
            'Student Registration: $studentRegistration\nTeacher Number: $teacherNumber\nPaper: $selectedPaper\nDate: ${selectedDate?.toLocal()}\nUnfair Means Type: $unfairType\nDetails (if any): $otherUnfairType',
        btnOkOnPress: () {
          Get.back();
        },
        btnOkText: 'OK',
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white, // Change your color here
        ),
        title: const Text(
          'Unfair Means Report',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            // color: Colors.blue,
            ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Student Registration
                  TextFormField(
                    onSaved: (value) => studentRegistration = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the student registration number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Student Registration',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Teacher Number
                  TextFormField(
                    onSaved: (value) => teacherNumber = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the teacher number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Teacher Number',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Paper Dropdown
                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedPaper,
                      hint: const Text('Select Paper'),
                      onChanged: (value) =>
                          setState(() => selectedPaper = value),
                      validator: (value) =>
                          value == null ? 'Please select a paper' : null,
                      items: papers
                          .map((paper) => DropdownMenuItem(
                              value: paper, child: Text(paper)))
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Paper',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date Picker
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: selectedDate != null
                              ? "${selectedDate!.toLocal()}".split(' ')[0]
                              : '',
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Unfair Means Type Dropdown
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: unfairType,
                      hint: const Text('Select Unfair Means Type'),
                      onChanged: (value) {
                        setState(() {
                          unfairType = value;
                        });
                      },
                      validator: (value) => value == null
                          ? 'Please select the unfair type'
                          : null,
                      items: [
                        'Phone',
                        'Paper',
                        'Other',
                      ]
                          .map((type) =>
                              DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Unfair Means Type',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // If "Other" is selected, show an additional input field
                  if (unfairType == 'Other')
                    TextFormField(
                      onSaved: (value) => otherUnfairType = value,
                      decoration: const InputDecoration(
                        labelText: 'Specify Other Unfair Means',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 32), // Add horizontal padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Submit Report',
                      style: TextStyle(color: Color(0xffffffff)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
