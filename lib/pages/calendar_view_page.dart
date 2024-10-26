// lib/pages/calendar_view_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import '../controllers/booking_controller.dart';
import '../models/booking_model.dart';

/// CalendarViewPage displays all bookings in a calendar view.
/// Users can switch between day, week, and month views.
/// Selecting a booking shows its details.
/// Mechanics can filter to see only their assigned bookings.
class CalendarViewPage extends StatefulWidget {
  @override
  _CalendarViewPageState createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  late final ValueNotifier<List<BookingModel>> _selectedBookings;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Instances of controllers
  final BookingController bookingController = Get.find<BookingController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedBookings = ValueNotifier(_getBookingsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedBookings.dispose();
    super.dispose();
  }

  /// Retrieves bookings for a specific day
  List<BookingModel> _getBookingsForDay(DateTime day) {
    return bookingController.bookings.where((booking) {
      DateTime bookingDay = booking.startDatetime.toDate();
      return isSameDay(bookingDay, day);
    }).toList();
  }

  /// Groups bookings by date for the calendar
  Map<DateTime, List<BookingModel>> _groupBookings(List<BookingModel> bookings) {
    Map<DateTime, List<BookingModel>> data = {};
    for (var booking in bookings) {
      DateTime date = DateTime(
          booking.startDatetime.toDate().year,
          booking.startDatetime.toDate().month,
          booking.startDatetime.toDate().day);
      if (data[date] == null) {
        data[date] = [booking];
      } else {
        data[date]!.add(booking);
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bookings Calendar'),
        ),
        body: Obx(() {
          if (bookingController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          // Filter bookings based on user role
          List<BookingModel> bookings = authController.userRole.value == 'mechanic'
              ? bookingController.bookings
                  .where((b) => b.assignedMechanic == authController.user.value!.uid)
                  .toList()
              : bookingController.bookings;

          Map<DateTime, List<BookingModel>> groupedBookings = _groupBookings(bookings);

          return Column(
            children: [
              TableCalendar<BookingModel>(
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                eventLoader: (day) {
                  return groupedBookings[DateTime(day.year, day.month, day.day)] ?? [];
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _selectedBookings.value = _getBookingsForDay(selectedDay);
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  // Customize the calendar style as needed
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ValueListenableBuilder<List<BookingModel>>(
                  valueListenable: _selectedBookings,
                  builder: (context, value, _) {
                    if (value.isEmpty) {
                      return Center(child: Text('No bookings for this day.'));
                    }
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        final booking = value[index];
                        return Card(
                          child: ListTile(
                            title: Text(booking.bookingTitle),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Car: ${booking.carMake} ${booking.carModel} (${booking.carYear})'),
                                Text('Customer: ${booking.customerName}'),
                                Text(
                                    'Start: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.startDatetime.toDate())}'),
                                Text(
                                    'End: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.endDatetime.toDate())}'),
                                if (booking.assignedMechanic != null)
                                  Text('Mechanic ID: ${booking.assignedMechanic}'),
                              ],
                            ),
                            isThreeLine: true,
                            onTap: () {
                              // Display booking details or navigate to edit page
                              _showBookingDetails(booking);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }));
  }

  /// Displays a dialog with booking details
  void _showBookingDetails(BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(booking.bookingTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Car Details:'),
                Text(
                    '${booking.carMake} ${booking.carModel} (${booking.carYear})'),
                Text('Registration Plate: ${booking.registrationPlate}'),
                SizedBox(height: 8),
                Text('Customer Details:'),
                Text('Name: ${booking.customerName}'),
                Text('Phone: ${booking.customerPhone}'),
                Text('Email: ${booking.customerEmail}'),
                SizedBox(height: 8),
                Text('Booking Details:'),
                Text(
                    'Start: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.startDatetime.toDate())}'),
                Text(
                    'End: ${DateFormat('yyyy-MM-dd – kk:mm').format(booking.endDatetime.toDate())}'),
                if (booking.assignedMechanic != null)
                  Text('Assigned Mechanic ID: ${booking.assignedMechanic}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Close'),
            ),
            // Optionally, add edit or delete buttons if needed
          ],
        );
      },
    );
  }
}
