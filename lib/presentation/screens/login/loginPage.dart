import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eis/presentation/widgets/custom_button.dart';
import 'package:eis/presentation/widgets/custom_text_field.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    print('Login with: ${emailController.text}');
  }

  void openQRCodeScanner() {
    print('QR code Scanner is Clicked.');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/logos/CUI WAH EIS.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: controller.emailController,
                labelText: 'Email/Username',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.passwordController,
                labelText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: controller.login,
                label: 'Login',
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?'),
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: controller.openQRCodeScanner,
                label: 'Scan QR Code',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
