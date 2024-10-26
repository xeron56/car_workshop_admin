// lib/controllers/auth_controller.dart

import 'package:car_workshop_admin/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// AuthController manages user authentication and user role management.
/// It uses Firebase Authentication for auth operations and Firestore for storing user roles.
class AuthController extends GetxController {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  var isLoading = false.obs;
  var user = Rxn<User>();
  var userRole = ''.obs;
  var userModel = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    // Bind the auth state changes to the user observable
    user.bindStream(_auth.authStateChanges());
    // If user is already logged in, fetch their role
    ever(user, _setUser);
  }

  /// Determines the initial screen based on authentication and role
  void _setInitialScreen(User? user) async {
    if (user == null) {
      if (Get.currentRoute != Routes.LOGIN) {
        Get.offAllNamed(Routes.LOGIN);
      }
    } else {
      await _fetchUserRole(user.uid);
      if (Get.currentRoute != Routes.WELCOME) {
        Get.offAllNamed(Routes.WELCOME);
      }
    }
  }

  void _setUser(User? user) async {
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      userModel.value = UserModel.fromFirestore(doc);
      await _fetchUserRole(user.uid);
      if (Get.currentRoute != Routes.ENTRY_POINT) {
        Get.offAllNamed(Routes.ENTRY_POINT);
      }
    } else {
      if (Get.currentRoute != Routes.WELCOME) {
        Get.offAllNamed(Routes.WELCOME);
      }
    }
  }

  /// Registers a new user with email and password and assigns a role
  Future<void> register(String email, String password, String role) async {
    try {
      isLoading.value = true;
      // Create user with Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user info to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role, // 'admin' or 'mechanic'
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update local observables
      user.value = userCredential.user;
      userRole.value = role;

      // Navigate to dashboard if not already there
      if (Get.currentRoute != Routes.WELCOME) {
        Get.offAllNamed(Routes.WELCOME);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Registration Error', e.message ?? 'Unknown error',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerUserWithRole(
      String email, String password, String role) async {
    try {
      isLoading.value = true;
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserModel newUser = UserModel(
        id: cred.user!.uid,
        email: email,
        role: role,
        createdAt: Timestamp.now(),
      );
      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(newUser.toMap());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Registration Error', e.message ?? 'Unknown error');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
  

  /// Logs in a user with email and password
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update local observables
      user.value = userCredential.user;

      // Fetch user role
      await _fetchUserRole(userCredential.user!.uid);

      // Navigate to dashboard if not already there
      if (Get.currentRoute != Routes.ENTRY_POINT) {
        Get.offAllNamed(Routes.ENTRY_POINT);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Error', e.message ?? 'Unknown error',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Logs out the current user
  Future<void> logout() async {
    try {
      await _auth.signOut();
      user.value = null;
      userRole.value = '';
      if (Get.currentRoute != Routes.WELCOME) {
        Get.offAllNamed(Routes.WELCOME);
      }
    } catch (e) {
      Get.snackbar('Logout Error', 'Failed to logout. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Fetches the user's role from Firestore
  Future<void> _fetchUserRole(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        userRole.value = doc['role'] ?? '';
      } else {
        userRole.value = '';
      }
    } catch (e) {
      userRole.value = '';
      Get.snackbar('Error', 'Failed to fetch user role.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
