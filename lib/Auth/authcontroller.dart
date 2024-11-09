import 'package:attendanceapp/Auth/authscreen.dart';
import 'package:attendanceapp/Home/home_controller.dart';
import 'package:attendanceapp/Home/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';




class AuthController extends GetxController{
  TextEditingController employeeId = TextEditingController();
  TextEditingController password = TextEditingController();


  var isPasswordVisible = false.obs;
  // Toggle the visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentUser();
    
  }


  RxBool userAvailable = false.obs;
  void getCurrentUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      // var data =  sharedPreferences.getString('EmployeeId'); //for debuging purpose
      userAvailable.value = sharedPreferences.getString('EmployeeId')?.isNotEmpty ?? false;
      // print("This is the::::::  $data"); //for debuging purpose
    } catch (e) {
      userAvailable.value = false;
    }
  }

  
}

class AuthCheck extends StatelessWidget {
  AuthCheck({Key? key}) : super(key: key);

  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.userAvailable.value){
        Future.microtask(()=>Get.offAll(
          ()=> NavScreen(),
          
          binding: BindingsBuilder(() {
                Get.put(HomeController());
              }),
        ),

        );
      }else {
        Future.microtask(()=> Get.offAll(()=> KeyboardVisibilityProvider(child: Authscreen())));
      }
      return const Center(child: CircularProgressIndicator(),);
    });
  }
}



