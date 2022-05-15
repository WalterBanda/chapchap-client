import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class GarageHome extends StatelessWidget {
  const GarageHome({Key? key}) : super(key: key);

  static const String id = "home";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("Garage Home 🏠"),
        ),
      ),
    );
  }
}