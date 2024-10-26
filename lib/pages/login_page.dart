// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// LoginPage provides a user interface for users to log in.
/// It interacts with AuthController to handle authentication logic.
class LoginPage extends StatelessWidget {
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Instance of AuthController
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Workshop Admin Login'),
        centerTitle: true,
      ),
      body: Obx(() {
        return authController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Email Field
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16),
                      // Password Field
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 24),
                   
                      

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _login();
                          },
                          child: Text('Login'),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Registration Prompt (Optional)
                      // Uncomment if you have a registration flow
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Get.toNamed('/register-admin');
                            },
                            child: Text('Register'),
                          ),
                        ],
                      ),
                      
                    ],
                  ),
                ),
              );
      }),
    );
  }

  /// Handles the login action by invoking AuthController's login method
  void _login() {
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter both email and password.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Optionally, add more validation (e.g., email format)

    authController.login(email, password);
  }
}
