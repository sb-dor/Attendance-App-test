import 'package:attendanceapp/Home/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../ui_utils/size/size_config..dart';

class TodayScreen extends GetView<HomeController> {
  TodayScreen({super.key});

  final Color primary = Color(0xffeeef444c);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.getPercentSize(5)),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.getPercentSize(1),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                      fontFamily: 'Nexa-ExtraLight',
                      fontSize: SizeConfig.getPercentSize(5),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Employee " +
                        controller
                            .emloyeeId, //Employee Id fetched from SharedPrefrences
                    style: TextStyle(
                      fontFamily: 'Nexa-Heavy',
                      fontSize: SizeConfig.getPercentSize(5.5),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.getPercentSize(5),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Today's Status",
                    style: TextStyle(
                      fontFamily: 'Nexa-Heavy',
                      fontSize: SizeConfig.getPercentSize(5.5),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.getPercentSize(3),
                    bottom: SizeConfig.getPercentSize(5),
                  ),
                  height: SizeConfig.getPercentSize(38),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(2, 2)),
                      ],
                      borderRadius: BorderRadius.circular(
                        SizeConfig.getPercentSize(5),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Check In',
                              style: TextStyle(
                                fontFamily: 'Nexa-ExtraLight',
                                fontSize: SizeConfig.getPercentSize(5),
                              ),
                            ),
                            Text(
                              '09:00',
                              style: TextStyle(
                                fontFamily: 'Nexa-Heavy',
                                fontSize: SizeConfig.getPercentSize(4.5),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Check Out',
                              style: TextStyle(
                                fontFamily: 'Nexa-ExtraLight',
                                fontSize: SizeConfig.getPercentSize(5),
                              ),
                            ),
                            Text(
                              '--/--',
                              style: TextStyle(
                                fontFamily: 'Nexa-Heavy',
                                fontSize: SizeConfig.getPercentSize(4.5),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                        text: DateTime.now().day.toString(),
                        style: TextStyle(
                          color: primary,
                          fontSize: SizeConfig.getPercentSize(5),
                          fontFamily: 'Nexa-Heavy',
                        ),
                        children: [
                          TextSpan(
                              text: DateFormat(' MMMM yyyy')
                                  .format(DateTime.now()),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: SizeConfig.getPercentSize(5),
                                fontFamily: 'Nexa-Heavy',
                              ))
                        ]),
                  ),
                ),
                StreamBuilder<Object>(
                    stream: Stream.periodic(
                      Duration(seconds: 1),
                      (count) => (count),
                    ),
                    builder: (context, snapshot) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DateFormat('hh:mm:ss a').format(DateTime.now()
                              .toUtc()
                              .add(Duration(hours: 5, minutes: 30))),
                          style: TextStyle(
                              fontFamily: 'Nexa-ExtraLight',
                              fontSize: SizeConfig.getPercentSize(5)),
                        ),
                      );
                    }),
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.getPercentSize(10)),
                  child: Builder(builder: (context) {
                    final GlobalKey<SlideActionState> key =
                        GlobalKey(); //In Flutter, a GlobalKey gives you a way to uniquely identify a widget and access its state from anywhere in your code.
                    return SlideAction(
                      text: 'Slide to Check Out',
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'Nexa-ExtraLight',
                        fontSize: SizeConfig.getPercentSize(5),
                      ),
                      outerColor: Colors.white,
                      innerColor: primary,
                      key: key,
                      onSubmit: () async {
                        QuerySnapshot snap = await FirebaseFirestore.instance
                            .collection("Employee")
                            .where('id', isEqualTo: controller.emloyeeId)
                            .get();
                        //The reason we use snap.docs[0].id instead of snap.doc.id is
                        //because QuerySnapshot (the type returned by .get()) contains a list of documents
                        //that match the query, even if there's only one document in the result.
                        // print(snap.docs[0].id);

                        /*--"Record" subcollection and the monthly document are automatically created 
                        when we use .set() or .update() for the first time, Firestore will automatically create the collection.--*/

                        //This snap2 will contain today’s document if it exists; otherwise, it will be empty.
                        DocumentSnapshot snap2 = await FirebaseFirestore
                            .instance
                            .collection("Employee")
                            .doc(snap.docs[0].id)
                            .collection("Record")
                            .doc(DateFormat('dd MMMM yyyy')
                                .format(DateTime.now()))
                            .get();

                        try {
                          //If Check-In Exists OR If CheckIn has done already.
                          String CheckIn = snap2['checkIn'];
                          await FirebaseFirestore.instance
                              .collection("Employee")
                              .doc(snap.docs[0].id)
                              .collection("Record")
                              .doc(DateFormat('dd MMMM yyyy')
                                  .format(DateTime.now()))
                              .update({
                            'checkIn':
                                CheckIn, //Retrieve the existing checkIn time.
                            'checkOut':
                                DateFormat("hh:mm").format(DateTime.now()),
                          });
                        } catch (e) {
                          //If No Check-In Exists OR If checkIn for first time.
                          await FirebaseFirestore.instance
                              .collection("Employee")
                              .doc(snap.docs[0].id)
                              .collection("Record")
                              .doc(DateFormat('dd MMMM yyyy')
                                  .format(DateTime.now()))
                              .set({
                            'checkIn':
                                DateFormat("hh:mm").format(DateTime.now()),
                          });
                        }
                      },
                    );
                  }),
                )
              ],
            ),
          ),
        ));
  }
}
