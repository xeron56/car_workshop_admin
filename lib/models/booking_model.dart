// lib/models/booking_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

/// BookingModel represents a car service booking.
class BookingModel {
  String? id;
  String carMake;
  String carModel;
  int carYear;
  String registrationPlate;
  String customerName;
  String customerPhone;
  String customerEmail;
  String bookingTitle;
  Timestamp startDatetime;
  Timestamp endDatetime;
  String? assignedMechanic;

  BookingModel({
    this.id,
    required this.carMake,
    required this.carModel,
    required this.carYear,
    required this.registrationPlate,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.bookingTitle,
    required this.startDatetime,
    required this.endDatetime,
    this.assignedMechanic,
  });

  /// Factory method to create a BookingModel from Firestore document
  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      carMake: data['car_make'] ?? '',
      carModel: data['car_model'] ?? '',
      carYear: data['car_year']?.toInt() ?? 0,
      registrationPlate: data['registration_plate'] ?? '',
      customerName: data['customer_name'] ?? '',
      customerPhone: data['customer_phone'] ?? '',
      customerEmail: data['customer_email'] ?? '',
      bookingTitle: data['booking_title'] ?? '',
      startDatetime: data['start_datetime'] ?? Timestamp.now(),
      endDatetime: data['end_datetime'] ?? Timestamp.now(),
      assignedMechanic: data['assigned_mechanic'],
    );
  }

  /// Converts BookingModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'car_make': carMake,
      'car_model': carModel,
      'car_year': carYear,
      'registration_plate': registrationPlate,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_email': customerEmail,
      'booking_title': bookingTitle,
      'start_datetime': startDatetime,
      'end_datetime': endDatetime,
      'assigned_mechanic': assignedMechanic,
    };
  }
}
