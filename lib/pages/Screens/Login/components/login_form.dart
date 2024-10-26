// lib/components/login_form.dart

import 'package:car_workshop_admin/controllers/auth_controller.dart';
import 'package:car_workshop_admin/pages/components/already_have_an_account_acheck.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

// Adjust the import path as necessary

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Instance of AuthController
  final AuthController authController = Get.find<AuthController>();

  // Key for the form
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Handles the login action by invoking AuthController's login method
  void _login() {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text;

      authController.login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            // Email Field
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                // Basic email validation
                if (!GetUtils.isEmail(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  // You can add more password validation if needed
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Your password",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            // Login Button or Loading Indicator
            authController.isLoading.value
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  )
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // Full width
                    ),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
            const SizedBox(height: defaultPadding),
            // Already have an account check
            AlreadyHaveAnAccountCheck(
              press: () {
               Get.toNamed('/register-admin');
              },
            ),
          ],
        ),
      );
    });
  }
}
