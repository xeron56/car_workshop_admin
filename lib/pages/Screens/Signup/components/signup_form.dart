// lib/components/sign_up_form.dart

import 'package:car_workshop_admin/controllers/auth_controller.dart';
import 'package:car_workshop_admin/pages/components/already_have_an_account_acheck.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../Login/login_screen.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Selected role
  String selectedRole = 'admin'; // Default role

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

  /// Handles the registration action by invoking AuthController's register method
  void _register() {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text;
      String role = selectedRole;

      authController.registerUserWithRole(email, password, role);
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
                if (!GetUtils.isEmail(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email),
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
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
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
            // Role Dropdown
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: InputDecoration(
                labelText: 'Role',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person_outline),
                ),
                border: OutlineInputBorder(),
              ),
              items: ['admin', 'mechanic']
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.capitalizeFirst!),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a role';
                }
                return null;
              },
            ),
            const SizedBox(height: defaultPadding / 2),
            // Register Button or Loading Indicator
            authController.isLoading.value
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  )
                : ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // Full width
                    ),
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
            const SizedBox(height: defaultPadding),
            // Already have an account check
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                 Get.toNamed('/welcome');
                
              },
            ),
          ],
        ),
      );
    });
  }
}
