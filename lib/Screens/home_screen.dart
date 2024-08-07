import 'package:flutter/material.dart';
import 'package:soccer_app/Screens/Widgets/text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MediumText(title: 'HomeScreen'),
      ),
    );
  }
}
