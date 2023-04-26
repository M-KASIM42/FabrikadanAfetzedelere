import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Center(
        child: Text("My Account Page"),
      ),
    );
  }
}