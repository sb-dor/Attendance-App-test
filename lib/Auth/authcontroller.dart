import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AuthController extends GetxController{
  TextEditingController employeeId = TextEditingController();
  TextEditingController password = TextEditingController();


  var isPasswordVisible = false.obs;
  // Toggle the visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}