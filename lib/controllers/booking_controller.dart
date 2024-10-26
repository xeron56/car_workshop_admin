// lib/controllers/booking_controller.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/booking_model.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

/// BookingController manages booking operations such as creating,
/// fetching, and assigning bookings to mechanics.
/// It interacts with Firebase Firestore for data persistence.
class BookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  var isLoading = false.obs;
  var bookings = <BookingModel>[].obs;
  var mechanics = <UserModel>[].obs;
  var selectedDataType;

  // Reference to AuthController to get current user and role
  final AuthController _authController = Get.find<AuthController>();
  StreamSubscription? _bookingSubscription;

  @override
  void onInit() {
    super.onInit();
    // Fetch bookings and mechanics when the controller is initialized
    fetchBookings();
    fetchMechanics();
  }

  /// Fetches all bookings from Firestore
  // Future<void> fetchBookings() async {
  //   try {
  //     isLoading.value = true;
  //     QuerySnapshot snapshot = await _firestore.collection('bookings').orderBy('start_datetime').get();
  //     bookings.value = snapshot.docs
  //         .map((doc) => BookingModel.fromFirestore(doc))
  //         .toList();
  //     print(">>>>>>>>>>> booking ${bookings[0].id}");    
  //   } catch (e) {
  //     print(e);
  //     Get.snackbar('Error', 'Failed to fetch bookings.');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      String? role = _authController.userModel.value?.role;
      String uid = _authController.user.value!.uid;

      Query query;

      if (role == 'admin') {
        // Admins can fetch all bookings
        query = _firestore.collection('bookings').orderBy('start_datetime');
      } else if (role == 'mechanic') {
        // Mechanics can fetch only bookings assigned to them
        query = _firestore
            .collection('bookings')
            .where('assigned_mechanic', isEqualTo: uid)
            .orderBy('start_datetime');
      } else {
        // Regular users can fetch only their own bookings
        query = _firestore
            .collection('bookings')
            .where('user_id', isEqualTo: uid)
            .orderBy('start_datetime');
      }

      _bookingSubscription?.cancel();
      _bookingSubscription = query.snapshots().listen((snapshot) {
        bookings.value = snapshot.docs
            .map((doc) => BookingModel.fromFirestore(doc))
            .toList();
      print(">>>>>>>>>>> booking ${bookings[0].id}");      
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch bookings.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches all mechanics from Firestore
  Future<void> fetchMechanics() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').where('role', isEqualTo: 'mechanic').get();
      mechanics.value = snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
     //print machanics
      print(">>>>>>>>>>> mechanic ${mechanics[0].email}");     
    } catch (e) {
      //print error message
      print(e);
      Get.snackbar('Error', 'Failed to fetch mechanics.');
    }
  }

  /// Creates a new booking in Firestore
  Future<void> createBooking(BookingModel booking) async {
    try {
      isLoading.value = true;
      await _firestore.collection('bookings').add(booking.toMap());
      bookings.add(booking);
      Get.snackbar('Success', 'Booking created successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create booking.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Updates an existing booking in Firestore
  Future<void> updateBooking(String bookingId, BookingModel updatedBooking) async {
    try {
      isLoading.value = true;
      await _firestore.collection('bookings').doc(bookingId).update(updatedBooking.toMap());
      // Update the local list
      int index = bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        bookings[index] = updatedBooking;
        bookings.refresh();
      }
      Get.snackbar('Success', 'Booking updated successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update booking.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Deletes a booking from Firestore
  Future<void> deleteBooking(String bookingId) async {
    try {
      isLoading.value = true;
      await _firestore.collection('bookings').doc(bookingId).delete();
      bookings.removeWhere((b) => b.id == bookingId);
      Get.snackbar('Success', 'Booking deleted successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete booking.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Assigns a mechanic to a booking
  Future<void> assignMechanic(String bookingId, String mechanicId) async {
    try {
      isLoading.value = true;
      await _firestore.collection('bookings').doc(bookingId).update({
        'assigned_mechanic': mechanicId,
      });
      // Update the local list
      int index = bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        bookings[index].assignedMechanic = mechanicId;
        bookings.refresh();
      }
      Get.snackbar('Success', 'Mechanic assigned successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to assign mechanic.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches bookings assigned to the current mechanic
  Future<void> fetchMechanicBookings(String mechanicId) async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('assigned_mechanic', isEqualTo: mechanicId)
          .orderBy('start_datetime')
          .get();
      bookings.value = snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch your bookings.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Example method using Dio for an external API call
  /// This is just a placeholder to demonstrate Dio usage
  // Future<void> fetchExternalBookings() async {
  //   // Replace with your actual API endpoint
  //   String apiUrl = 'https://api.example.com/bookings';

  //   try {
  //     isLoading.value = true;
  //     Response response = await Dio().get(apiUrl);
  //     // Process the response and update bookings if needed
  //     print(response.data);
  //   } catch (e) {
  //     Get.snackbar('API Error', 'Failed to fetch external bookings.');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
