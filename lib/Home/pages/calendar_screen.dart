import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Calendar Screen',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
