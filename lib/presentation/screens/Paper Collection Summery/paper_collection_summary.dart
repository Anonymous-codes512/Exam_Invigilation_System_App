import 'package:eis/core/constants/AppColors.dart';
import 'package:eis/core/constants/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // Import AwesomeDialog

class PaperCollectionScreen extends StatefulWidget {
  const PaperCollectionScreen({super.key});

  @override
  _PaperCollectionScreenState createState() => _PaperCollectionScreenState();
}

class _PaperCollectionScreenState extends State<PaperCollectionScreen> {
  final List<String> papers = [
    'CSC496 DWH & DM',
    'CSC461 ITDS',
    'CSC475 NC',
    'CSE498 SDP',
    'CSE455 ST',
  ];

  String? selectedPaper;
  int totalPapers = 0;
  int numberOfPapers = 0;
  String? collectorName;
  final _formKey = GlobalKey<FormState>();

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: 'Paper Collection Submitted',
        desc:
            'Paper: $selectedPaper\nTotal Papers: $totalPapers\nPapers Collected: $numberOfPapers\nCollector: $collectorName',
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
      body: Container(
        decoration: BoxDecoration(
            // color: AppColors.primaryColor,
            ),
        child: Center(
          // Center the entire form
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center fields horizontally
                children: [
                  Container(
                    // width: MediaQuery.of(context).size.width * 0.8, // 80% width
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        // borderRadius: BorderRadius.circular(30),
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

                  // Total Papers Input
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
                    decoration: const InputDecoration(
                      labelText: 'Total Number of Papers',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Collected Papers Input
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
                    decoration: const InputDecoration(
                      labelText: 'Number of Papers Collected',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Collector's Name Input
                  TextFormField(
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
                    decoration: const InputDecoration(
                      labelText: 'Collector\'s Name',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
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
                      'Submit Collection',
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
