import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petagram/controllers/auth_controller.dart';
import 'package:petagram/utils/paw_painter.dart';
import 'package:petagram/widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      body: Stack(children: [
        CustomPaint(
          size: Size.infinite,  
          painter: PawBackgroundPainter(),
        ),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 100), // Logo
                const SizedBox(height: 10),
                Text(
                  'Welcome to Petagram!',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Email',
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          icon: Icons.lock,
                          isPassword: true,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                          ),
                          onPressed: () {
                            _authController.login(_emailController.text,
                                _passwordController.text);
                          },
                          child: const Text('Login',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () => Get.toNamed('/register'),
                          child: const Text('Don\'t have an account?',
                              style: TextStyle(color: Colors.brown)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
