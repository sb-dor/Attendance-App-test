import 'package:attendanceapp/Home/pages/calendar_screen.dart';
import 'package:attendanceapp/Home/pages/profile_screen.dart';
import 'package:attendanceapp/Home/pages/today_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<IconData> navigationIcons = [
    Icons.calendar_month_outlined,
    Icons.check_sharp,
    Icons.person_outlined,
  ];

  final List<Widget> screens = [
    CalendarScreen(),
    TodayScreen(),
    ProfileScreen(),
  ];

  var currentIndex = 0.obs; // Observable for the current index
  // Method to handle navigation or showing content
  void onIconTapped(int index) {
    currentIndex.value = index; // Update the current index
    // Add navigation logic here based on index
    // For example:
    if (index == 0) {
      print('Home');
      // Get.to(HomeScreen());
    } else if (index == 1) {
      print('Today');
      Get.to(TodayScreen());
    } else if (index == 2) {
      print('Profile');
      // Get.to(ProfileScreen());
    }
  }
}
