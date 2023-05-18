
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main(List<String> args) {
  loadIlceler();
  

}
 loadIlceler() async {
    String jsonString = await rootBundle.loadString('assets/veri.json');
    List<dynamic> data = json.decode(jsonString);
    debugPrint(data.toString());
  }