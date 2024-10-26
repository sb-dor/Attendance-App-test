import 'package:attendanceapp/Auth/authcontroller.dart';
import 'package:attendanceapp/Auth/authscreen.dart';
import 'package:attendanceapp/Home/home_controller.dart';
import 'package:attendanceapp/Home/nav_screen.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import 'pages_name.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.auth,
      page: () => KeyboardVisibilityProvider(child: Authscreen()),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),

    GetPage(
      name: Routes.nav,
      page: () => NavScreen(),
       binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
    ),
    // GetPage(
    //   name: Routes.profile,
    //   page: () => ProfileScreen(),
    // ),
  ];
}
