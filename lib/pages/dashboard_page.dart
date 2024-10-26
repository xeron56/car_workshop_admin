// lib/pages/dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/booking_controller.dart';
import 'booking_form_page.dart';
import 'calendar_view_page.dart';

/// DashboardPage serves as the main dashboard for authenticated users.
/// It displays different content based on the user's role (admin or mechanic).
class DashboardPage extends StatelessWidget {
  // Instances of controllers
  final AuthController authController = Get.find<AuthController>();
  final BookingController bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          // Logout Button
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Obx(() {
        if (bookingController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Determine user role
        String role = authController.userRole.value;

        if (role == 'admin') {
          return _buildAdminDashboard();
        } else if (role == 'mechanic') {
          return _buildMechanicDashboard();
        } else {
          return Center(child: Text('Unknown role.'));
        }
      }),
      floatingActionButton: Obx(() {
        // Only show FAB for admin to create a new booking
        return authController.userRole.value == 'admin'
            ? FloatingActionButton(
                onPressed: () {
                  Get.to(() => BookingFormPage());
                },
                child: Icon(Icons.add),
                tooltip: 'Create Booking',
              )
            : Container(); // Empty container for mechanics
      }),
    );
  }

  /// Builds the admin dashboard view
  Widget _buildAdminDashboard() {
    return RefreshIndicator(
      onRefresh: () async {
        await bookingController.fetchBookings();
      },
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Welcome Message
          Text(
            'Welcome, Admin!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Summary Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryCard('Total Bookings', bookingController.bookings.length.toString()),
              _buildSummaryCard('Total Mechanics', bookingController.mechanics.length.toString()),
            ],
          ),
          SizedBox(height: 24),
          // Bookings List
          Text(
            'All Bookings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          bookingController.bookings.isEmpty
              ? Center(child: Text('No bookings available.'))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bookingController.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookingController.bookings[index];
                    return Card(
                      child: ListTile(
                        title: Text(booking.bookingTitle),
                        subtitle: Text(
                            '${booking.carMake} ${booking.carModel} (${booking.carYear})\nCustomer: ${booking.customerName}\nStart: ${booking.startDatetime.toDate()}'),
                        isThreeLine: true,
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigate to booking details or edit page
                          // Implement as needed
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  /// Builds the mechanic dashboard view
  Widget _buildMechanicDashboard() {
    return RefreshIndicator(
      onRefresh: () async {
        // Fetch bookings assigned to the mechanic
        await bookingController.fetchMechanicBookings(authController.user.value!.uid);
      },
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Welcome Message
          Text(
            'Welcome, Mechanic!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Summary Card
          _buildSummaryCard(
              'Your Bookings', bookingController.bookings.length.toString()),
          SizedBox(height: 24),
          // Assigned Bookings List
          Text(
            'Your Assigned Bookings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          bookingController.bookings.isEmpty
              ? Center(child: Text('No bookings assigned to you.'))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bookingController.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookingController.bookings[index];
                    return Card(
                      child: ListTile(
                        title: Text(booking.bookingTitle),
                        subtitle: Text(
                            '${booking.carMake} ${booking.carModel} (${booking.carYear})\nCustomer: ${booking.customerName}\nStart: ${booking.startDatetime.toDate()}'),
                        isThreeLine: true,
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigate to booking details page
                          // Implement as needed
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  /// Helper method to build summary cards
  Widget _buildSummaryCard(String title, String count) {
    return Card(
      elevation: 4,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
