// lib/routes/app_pages.dart

import 'package:car_workshop_admin/admin/pages/entry_point.dart';
import 'package:car_workshop_admin/pages/Screens/Login/components/login_form.dart';
import 'package:car_workshop_admin/pages/Screens/Signup/signup_screen.dart';
import 'package:car_workshop_admin/pages/Screens/Welcome/welcome_screen.dart';
import 'package:car_workshop_admin/pages/booking_form_page.dart';
import 'package:car_workshop_admin/pages/register_admin_page.dart';
import 'package:get/get.dart';
import '../pages/login_page.dart';
import '../pages/dashboard_page.dart';
import '../bindings/auth_binding.dart';
import '../bindings/booking_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.WELCOME;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginForm(),
      //binding: AuthBinding(),
    ),
   
     GetPage(
      name: Routes.REGISTER,
      page: () => SignUpScreen(),
    ),
    //welcome page
    GetPage(
      name: Routes.WELCOME,
      page: () => WelcomeScreen(),
    ),
    //EntryPoint
    GetPage(
      name: Routes.ENTRY_POINT,
      page: () => EntryPoint(),
      bindings:[
        BookingBinding(),
      ] 
    ),
    //BOOKING_FORM
    GetPage(
      name: Routes.BOOKING_FORM,
      page: () => BookingFormPage(),
      bindings:[
        BookingBinding(),
      ] 
    ),
    // Add other pages here, e.g., BookingFormPage, CalendarViewPage
  ];

  
}
