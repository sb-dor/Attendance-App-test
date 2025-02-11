import 'package:attendanceapp/Home/home_controller.dart';
import 'package:attendanceapp/Home/pages/calendar_screen.dart';
import 'package:attendanceapp/Home/pages/profile_screen.dart';
import 'package:attendanceapp/Home/pages/today_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../ui_utils/size/size_config..dart';

class NavScreen extends GetView<HomeController> {
  const NavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // Initialize SizeConfig before using it
    final Color primary = Color(0xffeeef444c);

    return GetBuilder<HomeController>(
      builder: (controller){
        return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            CalendarScreen(),
            TodayScreen(),
            ProfileScreen(),
          ],
        )
        ),
      bottomNavigationBar: 
      
      Container(
        height: SizeConfig.getPercentSize(18),
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 24,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SizeConfig.getPercentSize(15)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0;
                i < controller.navigationIcons.length;
                i++) ...<Expanded>{
              Expanded(
                child: Center(
                  child: GestureDetector(onTap: () {
                    controller.onIconTapped(i);
                  }, child: 
                    Icon(
                      controller.navigationIcons[i],
                      size: controller.currentIndex.value == i
                          ? SizeConfig.getPercentSize(10) 
                          : SizeConfig.getPercentSize(8),
                      color: controller.currentIndex.value == i
                          ? primary
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            }
          ],
        ),
      ),
    );
  }
     );
      }
    
}
