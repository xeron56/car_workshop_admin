// lib/pages/register_admin_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';

class RegisterAdminPage extends StatefulWidget {
  @override
  _RegisterAdminPageState createState() => _RegisterAdminPageState();
}

class _RegisterAdminPageState extends State<RegisterAdminPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedRole = 'mechanic'; // Default role

  final AuthController authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Admin/Mechanic'),
      ),
      body: Obx(() {
        return authController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email Field
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter email';
                            }
                            if (!GetUtils.isEmail(value.trim())) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        // Password Field
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        // Role Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedRole,
                          decoration: InputDecoration(
                            labelText: 'Role',
                            border: OutlineInputBorder(),
                          ),
                          items: ['admin', 'mechanic']
                              .map((role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(role.capitalize!),
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
                        SizedBox(height: 24),
                        // Register Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _register,
                            child: Text('Register'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      }),
    );
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text;
      String role = selectedRole;

      authController.registerUserWithRole(email, password, role).then((_) {
        Get.back();
        Get.snackbar('Success', '$role registered successfully.',
            snackPosition: SnackPosition.BOTTOM);
      }).catchError((error) {
        Get.snackbar('Error', 'Failed to register $role.',
            snackPosition: SnackPosition.BOTTOM);
      });
    }
  }
}
