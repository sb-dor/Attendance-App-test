import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getEmloyeeId();
    _getRecord();
  }

  List<IconData> navigationIcons = [
    Icons.calendar_month_outlined,
    Icons.check_sharp,
    Icons.person_outlined,
  ];

  var currentIndex = 0.obs; // Observable for the current index
  // Method to handle navigation or showing content
  void onIconTapped(int index) {
    currentIndex.value = index; // Update the current index
    update();
  }

  String emloyeeId = ''; //To display employee id on Today Screen
  void getEmloyeeId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = sharedPreferences.getString('EmployeeId');
    emloyeeId = data.toString();
  }

  RxString checkIn = '--/--'.obs;
  RxString checkOut = '--/--'.obs;

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where('id', isEqualTo: emloyeeId)
          .get();

      print(snap.docs[0].id);

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();
      // print('CheckIn in doc: $snap2[checkIn]');

      checkIn.value = snap2['checkIn'];
      checkOut.value = snap2['checkOut'];
    } catch (e) {
      checkIn.value = '--/--';
      checkOut.value = '--/--';
    }

    print('CheckIn time : $checkIn');
    print('CheckOut time : $checkOut');
  }
}
