import 'package:car_workshop_admin/controllers/auth_controller.dart';
import 'package:car_workshop_admin/controllers/booking_controller.dart';
import 'package:car_workshop_admin/pages/booking_form_page.dart';
import 'package:car_workshop_admin/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BookingList extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final BookingController bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Bookings",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          Obx(() {
            if (bookingController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final String role = authController.userRole.value;
            final bookings = role == 'admin'
                ? bookingController.bookings
                : bookingController.bookings
                    .where((b) => b.assignedMechanic == authController.user.value?.uid)
                    .toList();

            if (bookings.isEmpty) {
              return Center(child: Text('No bookings available.'));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  child: ListTile(
                    title: Text(booking.bookingTitle),
                    subtitle: Text(
                      '${booking.carMake} ${booking.carModel} (${booking.carYear})\n'
                      'Customer: ${booking.customerName}\n'
                      'Start: ${booking.startDatetime.toDate()}',
                    ),
                    isThreeLine: true,
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Implement navigation to booking details or edit page if necessary
                    },
                  ),
                );
              },
            );
          }),
          const Divider(),
          OutlinedButton(
            onPressed: () {
              // popup this page  'BookingFormPage'
             //Get.toNamed(Routes.BOOKING_FORM);
                Get.dialog(
                Dialog(
                  backgroundColor: Colors.transparent,
                  child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4, // Decrease the width
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: BookingFormPage(), // Replace with your BookingFormPage widget
                  ),
                  ),
                ),
                barrierColor: Colors.black.withOpacity(0.5),
                );



            },
            child: Text(
              "Add New Booking",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
