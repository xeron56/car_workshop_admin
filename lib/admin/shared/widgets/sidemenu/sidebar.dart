import 'package:car_workshop_admin/admin/pages/dashboard/widgets/theme_tabs.dart';
import 'package:car_workshop_admin/admin/responsive.dart';
import 'package:car_workshop_admin/admin/shared/constants/defaults.dart';
import 'package:car_workshop_admin/admin/shared/constants/ghaps.dart';
import 'package:car_workshop_admin/admin/shared/widgets/sidemenu/customer_info.dart';
import 'package:car_workshop_admin/controllers/auth_controller.dart';
import 'package:car_workshop_admin/controllers/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/config.dart';

class Sidebar extends StatelessWidget {
  // const Sidebar({super.key});
   // Instances of controllers
  final AuthController authController = Get.find<AuthController>();
  final BookingController bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // width: Responsive.isMobile(context) ? double.infinity : null,
      // width: MediaQuery.of(context).size.width < 1300 ? 260 : null,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (Responsive.isMobile(context))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDefaults.padding,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset('assets/icons/close_filled.svg'),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDefaults.padding,
                    vertical: AppDefaults.padding * 1.5,
                  ),
                  child: SvgPicture.asset(AppConfig.logo),
                ),
              ],
            ),
            const Divider(),
            gapH16,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                ),
                child: ListView(
                  children: [
                        
                   

                 
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDefaults.padding),
              child: Column(
                children: [
                  // if (Responsive.isMobile(context))
                    CustomerInfo(
                      name: authController.userRole.value == 'admin'
                          ? 'Admin'
                          : 'Mechanic',
                      designation: 'Car Workshop',
                      imageSrc:
                          'https://cdn.create.vista.com/api/media/small/339818716/stock-photo-doubtful-hispanic-man-looking-with-disbelief-expression',
                      onLogout: () {
                        authController.logout();
                      },
                    ),
                  gapH8,
                  const Divider(),
                  
                  gapH20,
                  const ThemeTabs(),
                  gapH8,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
