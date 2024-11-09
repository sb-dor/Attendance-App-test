import 'package:attendanceapp/Auth/authcontroller.dart';
import 'package:attendanceapp/ui_utils/size/size_config..dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/pages_name.dart';

class Authscreen extends GetView<AuthController> {
  Authscreen({super.key});

  final Color primary = Color(0xffeeef444c);
  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // Initialize SizeConfig before using it
    final bool isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              isKeyboardVisible
                  ? SizedBox(
                      height: SizeConfig.getPercentSize(20),
                    )
                  : Container(
                      height: SizeConfig.getPercentSize(65),
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(
                              SizeConfig.getPercentSize(20),
                            ),
                          )),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: SizeConfig.getPercentSize(20),
                        ),
                      ),
                    ),
              SizedBox(
                height: SizeConfig.getPercentSize(10),
              ),
              Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Nexa-Heavy',
                  fontSize: SizeConfig.getPercentSize(6),
                ),
              ),
              SizedBox(
                height: SizeConfig.getPercentSize(10),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //-------------Employeee Field--------------------------
                fieldTitle('Employee ID'),
                SizedBox(
                  height: SizeConfig.getPercentSize(2.5),
                ),
                Container(
                  height: SizeConfig.getPercentSize(15),
                  margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getPercentSize(10),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SizeConfig.getPercentSize(3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.getPercentSize(5)),
                        child: Icon(
                          Icons.person,
                          color: Color(0xffeeef444c), // Use any color like your primary color
                          size: SizeConfig.getPercentSize(6),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: controller.employeeId,
                          decoration: InputDecoration(
                            hintText: 'Enter your employee id',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.getPercentSize(5),
                ),
                //-------------Password--------------------------
                fieldTitle('Password'),
                SizedBox(
                  height: SizeConfig.getPercentSize(2.5),
                ),
                Container(
                  height: SizeConfig.getPercentSize(15),
                  margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getPercentSize(10),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SizeConfig.getPercentSize(3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: SizeConfig.getPercentSize(5)),
                        child: Icon(
                          Icons.vpn_key_sharp,
                          color: Color(0xffeeef444c), // Use any color like your primary color
                          size: SizeConfig.getPercentSize(6),
                        ),
                      ),
                      Expanded(
                        child: Obx(() {
                          return TextFormField(
                            controller: controller.password,
                            obscureText: !controller.isPasswordVisible.value,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: SizeConfig.getPercentSize(3.2)),
                                hintText: 'Enter your passowrd',
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xffeeef444c),
                                  ),
                                  onPressed: () {
                                    // Toggle password visibility
                                    controller.togglePasswordVisibility();
                                  },
                                )),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: SizeConfig.getPercentSize(5),
                ),
                //------------------Button-------------------
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: SizeConfig.getPercentSize(15),
                    width: SizeConfig.getPercentSize(80),
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        String id = controller.employeeId.text.trim();
                        String password = controller.password.text.trim();

                        if (id.isEmpty) {
                          Get.showSnackbar(GetSnackBar(
                            message: 'Employee id is still empty!',
                            duration: const Duration(seconds: 2),
                          ));
                        } else if (password.isEmpty) {
                          Get.showSnackbar(GetSnackBar(
                            message: 'Password is still empty!',
                            duration: const Duration(seconds: 2),
                          ));
                        } else {
                          //Query that retrive the data based on condtion
                          //Which is id(in database) = id(Writern in textfield)
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("Employee")
                              .where('id', isEqualTo: id)
                              .get();
                          debugPrint("is data coming though: $snap");
                          try {
                            if (password == snap.docs[0]['password']) {
                              sharedPreferences = await SharedPreferences.getInstance();

                              // sharedPreferences.setString('EmployeeId', id).then((_){
                              // Get.offNamed(Routes.nav);
                              // });
                              sharedPreferences.setString('EmployeeId', id);
                            } else {
                              Get.showSnackbar(GetSnackBar(
                                message: 'Password is not correct!',
                                duration: const Duration(seconds: 2),
                              ));
                            }
                          } catch (e) {
                            RxString error = ''.obs;
                            if (e.toString() ==
                                'RangeError (length): Invalid value: Valid value range is empty: 0') {
                              error.value = 'User does not exist';
                            } else {
                              error.value = 'Error Occurred!';
                            }
                            Get.showSnackbar(GetSnackBar(
                              message: error.value,
                              duration: const Duration(seconds: 2),
                            ));
                          }
                        }
                      },
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Nexa-Heavy",
                          fontSize: SizeConfig.getPercentSize(4),
                          letterSpacing: 2,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(primary),
                      ),
                    ),
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldTitle(String hintText) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getPercentSize(10),
      ),
      child: Text(
        hintText,
        style: TextStyle(
          fontFamily: 'Nexa-Heavy',
          fontSize: SizeConfig.getPercentSize(4),
        ),
      ),
    );
  }
}

class CustomFieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController textController;
  final bool hasSuffixIcon;
  final bool hasObsecureText;

  // Add the AuthController
  final AuthController authController = Get.put(AuthController());

  CustomFieldWidget({
    required this.hintText,
    required this.textController,
    this.hasSuffixIcon = false,
    required this.hasObsecureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.getPercentSize(15),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.getPercentSize(10),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.getPercentSize(3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.getPercentSize(5)),
            child: Icon(
              Icons.person,
              color: Color(0xffeeef444c), // Use any color like your primary color
              size: SizeConfig.getPercentSize(6),
            ),
          ),
          Expanded(
            child: Obx(() {
              return TextFormField(
                controller: textController,
                obscureText: hasObsecureText ? !authController.isPasswordVisible.value : false,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  suffixIcon: hasSuffixIcon
                      ? IconButton(
                          icon: Icon(
                            authController.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xffeeef444c),
                          ),
                          onPressed: () {
                            // Toggle password visibility
                            authController.togglePasswordVisibility();
                          },
                        )
                      : null, // Allow no suffixIcon if not provided
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
