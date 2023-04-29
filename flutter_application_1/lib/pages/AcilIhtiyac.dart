import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AcilIhtiyac extends StatefulWidget {
  const AcilIhtiyac({super.key});

  @override
  State<AcilIhtiyac> createState() => _AcilIhtiyacState();
}

class _AcilIhtiyacState extends State<AcilIhtiyac> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Column(
        children: [
          
          Center(
            child: Text("Acil İhtiyaçlar"),
          ),
        ],
      ),
    );
  }
}