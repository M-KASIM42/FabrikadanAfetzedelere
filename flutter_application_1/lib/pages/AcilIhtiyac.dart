// ignore_for_file: file_names

import 'package:flutter/material.dart';


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
        children: const [
          
          Center(
            child: Text("Acil İhtiyaçlar"),
          ),
        ],
      ),
    );
  }
}