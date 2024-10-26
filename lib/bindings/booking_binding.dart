// lib/bindings/booking_binding.dart

import 'package:get/get.dart';
import '../controllers/booking_controller.dart';

/// BookingBinding is responsible for binding the BookingController
/// to the dependency injection system using GetX.
class BookingBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy initialization of BookingController
    // The controller will be created when it's first used.
    Get.lazyPut<BookingController>(() => BookingController());

    //Get.put<BookingController>(BookingController(), permanent: true);
  }
}
