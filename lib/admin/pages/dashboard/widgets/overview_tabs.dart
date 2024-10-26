import 'package:car_workshop_admin/admin/pages/dashboard/widgets/anotherchart.dart';
import 'package:car_workshop_admin/controllers/auth_controller.dart';
import 'package:car_workshop_admin/controllers/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/constants/defaults.dart';
import '../../../shared/constants/ghaps.dart';
import '../../../shared/widgets/tabs/tab_with_growth.dart';
import '../../../theme/app_colors.dart';

import 'revenue_line_chart.dart';


class OverviewTabs extends StatefulWidget {
  const OverviewTabs({super.key});

  @override
  State<OverviewTabs> createState() => _OverviewTabsState();
}

class _OverviewTabsState extends State<OverviewTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthController authController = Get.find<AuthController>();
  final BookingController bookingController = Get.find<BookingController>();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      });

    // Fetch initial data
    bookingController.fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.bgLight,
            borderRadius: BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
          ),
          child: Obx(() {
            // Update tab labels based on data
            String customerCount = bookingController.bookings.length.toString();
            String revenueAmount = "\$128K"; // Placeholder; can be updated with actual revenue data

            return TabBar(
              controller: _tabController,
              dividerHeight: 0,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: AppDefaults.padding),
              indicator: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
                color: AppColors.bgSecondayLight,
              ),
              tabs: [
                TabWithGrowth(
                  title: authController.userRole.value == 'admin' ? "Total Booking" : "Bookings",
                  amount: bookingController.bookings.length.toString(),
                  growthPercentage: "20%", // Update based on real data if available
                ),
                TabWithGrowth(
                  title: authController.userRole.value == 'admin' ? "Total Mechanices" : "Total Mechanices",
                  iconSrc: "assets/icons/activity_light.svg",
                  iconBgColor: AppColors.secondaryLavender,
                  amount: bookingController.mechanics.length.toString(),
                  growthPercentage: "2.7%", // Update based on real data if available
                  isPositiveGrowth: false,
                ),
              ],
            );
          }),
        ),
        gapH24,
        // Obx(() {
        //   if (bookingController.isLoading.value) {
        //     return Center(child: CircularProgressIndicator());
        //   }

        //   return Column(
        //     children: [
        //       //CustomersOverview(),
        //       // Additional Admin-specific information
        //       // _buildSummaryCard("Total Bookings", bookingController.bookings.length.toString()),
        //       Padding(
        //         padding: EdgeInsets.symmetric(
        //           horizontal: AppDefaults.padding * 1.5,
        //           vertical: AppDefaults.padding,
        //         ),
        //         child: RevenueLineChart(),
        //       )
        //     ],
        //   );

          // Different tab content for admin and mechanic roles
          // return SizedBox(
          //   height: 280,
          //   child: TabBarView(
          //     controller: _tabController,
          //     physics: const NeverScrollableScrollPhysics(),
          //     children: [
          //       // Tab content for Customers Overview (Admin or Mechanic)
          //       if (authController.userRole.value == 'admin')
          //         Column(
          //           children: [
          //             //CustomersOverview(),
          //             // Additional Admin-specific information
          //             // _buildSummaryCard("Total Bookings", bookingController.bookings.length.toString()),
          //             Padding(
          //           padding: EdgeInsets.symmetric(
          //             horizontal: AppDefaults.padding * 1.5,
          //             vertical: AppDefaults.padding,
          //           ),
          //           child: RevenueLineChart(),
          //         )
          //           ],
          //         )
          //       else if (authController.userRole.value == 'mechanic')
          //         Column(
          //           children: [
          //             //CustomersOverview(),
          //             // Mechanic-specific data, e.g., Assigned bookings
          //             _buildSummaryCard("Your Bookings", bookingController.bookings.length.toString()),
          //           ],
          //         )
          //       else
          //         Center(child: Text('Unknown role.')),

          //       // Tab content for Revenue (Admin only)
          //       if (authController.userRole.value == 'admin')
          //         Padding(
          //           padding: EdgeInsets.symmetric(
          //             horizontal: AppDefaults.padding * 1.5,
          //             vertical: AppDefaults.padding,
          //           ),
          //           child: RevenueLineChart(),
          //         )
          //       else
          //         Center(child: Text('No revenue data available for role: ${authController.userRole.value}')),
          //     ],
          //   ),
          // );
        // }),
      ],
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
