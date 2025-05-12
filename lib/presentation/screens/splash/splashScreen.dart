import 'package:flutter/material.dart';
import 'package:eis/presentation/widgets/education_loader.dart';
import 'package:eis/presentation/screens/Teacher Attendance/teacher_attendance.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => TeacherQRScannerScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Expanded(
              flex: 3,
              child: Center(
                child: Image.asset(
                  'assets/images/logos/CUI WAH EIS.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, obj, st) => const Icon(
                    Icons.school,
                    size: 120,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),
            ),

            // App title
            const Text(
              'Exam Invigilation System',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),

            // Loader
            const Expanded(
              flex: 2,
              child: Center(
                child: EducationLoader(
                  message: 'Initializing System...',
                ),
              ),
            ),

            // Footer
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Powered by Danish Ejaz',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
