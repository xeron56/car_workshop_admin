// lib/pages/booking_form_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../controllers/booking_controller.dart';
import '../models/user_model.dart';
import '../models/booking_model.dart';

/// BookingFormPage allows admins to create a new car service booking.
/// It includes form fields for car details, customer details, booking details,
/// and assigns a mechanic to the booking.
class BookingFormPage extends StatefulWidget {
  @override
  _BookingFormPageState createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  // Controllers for form fields
  final TextEditingController carMakeController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carYearController = TextEditingController();
  final TextEditingController registrationPlateController =
      TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerPhoneController =
      TextEditingController();
  final TextEditingController customerEmailController =
      TextEditingController();
  final TextEditingController bookingTitleController = TextEditingController();

  // Selected start and end datetime
  DateTime? selectedStartDateTime;
  DateTime? selectedEndDateTime;

  // Selected mechanic
  UserModel? selectedMechanic;

  // Instance of BookingController
  final BookingController bookingController = Get.find<BookingController>();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    carMakeController.dispose();
    carModelController.dispose();
    carYearController.dispose();
    registrationPlateController.dispose();
    customerNameController.dispose();
    customerPhoneController.dispose();
    customerEmailController.dispose();
    bookingTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Booking'),
      ),
      body: Obx(() {
        return bookingController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car Details Section
                      Text(
                        'Car Details',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: carMakeController,
                        decoration: InputDecoration(
                          labelText: 'Make',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the car make';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: carModelController,
                        decoration: InputDecoration(
                          labelText: 'Model',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the car model';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: carYearController,
                        decoration: InputDecoration(
                          labelText: 'Year',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the car year';
                          }
                          if (int.tryParse(value.trim()) == null) {
                            return 'Please enter a valid year';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: registrationPlateController,
                        decoration: InputDecoration(
                          labelText: 'Registration Plate',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the registration plate';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Customer Details Section
                      Text(
                        'Customer Details',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: customerNameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the customer name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: customerPhoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the phone number';
                          }
                          // You can add more validation for phone number format
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: customerEmailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the email';
                          }
                          if (!GetUtils.isEmail(value.trim())) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Booking Details Section
                      Text(
                        'Booking Details',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: bookingTitleController,
                        decoration: InputDecoration(
                          labelText: 'Booking Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the booking title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      // Start Date & Time
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Start Date & Time'),
                        subtitle: Text(selectedStartDateTime != null
                            ? DateFormat('yyyy-MM-dd – kk:mm')
                                .format(selectedStartDateTime!)
                            : 'Select start date and time'),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () async {
                          DateTime? pickedDate = await _selectDateTime(
                              context, selectedStartDateTime);
                          if (pickedDate != null) {
                            setState(() {
                              selectedStartDateTime = pickedDate;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 8),
                      // End Date & Time
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('End Date & Time'),
                        subtitle: Text(selectedEndDateTime != null
                            ? DateFormat('yyyy-MM-dd – kk:mm')
                                .format(selectedEndDateTime!)
                            : 'Select end date and time'),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () async {
                          DateTime? pickedDate = await _selectDateTime(
                              context, selectedEndDateTime);
                          if (pickedDate != null) {
                            setState(() {
                              selectedEndDateTime = pickedDate;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 8),
                      // Assign Mechanic Dropdown
                      DropdownSearch<UserModel>(
                        popupProps: PopupProps.bottomSheet(
                          showSearchBox: true,
                        ),
                        //showSearchBox: true,
                        items: bookingController.mechanics.toList(),
                        itemAsString: (UserModel u) => u.email,
                        onChanged: (UserModel? selected) {
                          setState(() {
                            selectedMechanic = selected;
                          });
                        },
                        selectedItem: selectedMechanic,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a mechanic';
                          }
                          return null;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Assign Mechanic',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitBooking,
                          child: Text('Create Booking'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  /// Displays a date and time picker and returns the selected DateTime
  Future<DateTime?> _selectDateTime(
      BuildContext context, DateTime? initialDateTime) async {
    DateTime initialDate = initialDateTime ?? DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return null;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime:
          initialDateTime != null ? TimeOfDay.fromDateTime(initialDateTime) : TimeOfDay.now(),
    );

    if (pickedTime == null) return null;

    return DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute);
  }

  /// Handles the submission of the booking form
  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      if (selectedStartDateTime == null || selectedEndDateTime == null) {
        Get.snackbar('Error', 'Please select both start and end date & time.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      if (selectedEndDateTime!.isBefore(selectedStartDateTime!)) {
        Get.snackbar('Error', 'End date & time must be after start date & time.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      if (selectedMechanic == null) {
        Get.snackbar('Error', 'Please assign a mechanic.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Create a BookingModel instance
      BookingModel newBooking = BookingModel(
        carMake: carMakeController.text.trim(),
        carModel: carModelController.text.trim(),
        carYear: int.parse(carYearController.text.trim()),
        registrationPlate: registrationPlateController.text.trim(),
        customerName: customerNameController.text.trim(),
        customerPhone: customerPhoneController.text.trim(),
        customerEmail: customerEmailController.text.trim(),
        bookingTitle: bookingTitleController.text.trim(),
        startDatetime: Timestamp.fromDate(selectedStartDateTime!),
        endDatetime: Timestamp.fromDate(selectedEndDateTime!),
        assignedMechanic: selectedMechanic!.id,
      );

      // Submit the booking using BookingController
      bookingController.createBooking(newBooking).then((_) {
        // After successful creation, navigate back or reset the form
        Get.back();
        Get.snackbar('Success', 'Booking created successfully.',
            snackPosition: SnackPosition.BOTTOM);
      }).catchError((error) {
        Get.snackbar('Error', 'Failed to create booking.',
            snackPosition: SnackPosition.BOTTOM);
      });
    }
  }
}
