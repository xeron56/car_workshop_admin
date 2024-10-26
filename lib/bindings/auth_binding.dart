// lib/bindings/auth_binding.dart

import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Use Get.put with permanent:true to make it a singleton
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
