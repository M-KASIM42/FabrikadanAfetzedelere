// ignore_for_file: file_names, library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:convert';
import 'package:flutter/material.dart';

class AcilIhtiyac extends StatefulWidget {
  const AcilIhtiyac({super.key});
  @override
  State<AcilIhtiyac> createState() => _AcilIhtiyacState();
}

class _AcilIhtiyacState extends State<AcilIhtiyac> {

  Future<List<Map<String, dynamic>>> loadJsonData() async {
    String jsonString =
        await DefaultAssetBundle.of(context).loadString("assets/veri.json");
    List<dynamic> jsonData = json.decode(jsonString);
    List<Map<String, dynamic>> parsedData =
        jsonData.cast<Map<String, dynamic>>();
    return parsedData;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadJsonData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Veri yüklenirken bir hata oluştu.'),
          );
        } else {
          List<Map<String, dynamic>>? jsonData = snapshot.data;
          return ListView.builder(
            itemCount: jsonData!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> ilData = jsonData[index];
              String ilAdi = ilData['il_adi'];
              List<dynamic> ilceList = ilData['ilceler'] as List<dynamic>;
              List<Map<String, dynamic>> ilceler =
                  ilceList.cast<Map<String, dynamic>>();

              return ExpansionTile(
                title: Text(ilAdi),
                children: ilceler.map((ilceData) {
                  String ilceAdi = ilceData['ilce_adi'];
                  String veri1 = ilceData['ilce_kodu'];
                  String veri2 = ilceData['nufus'];

                  return ListTile(
                    title: Text(ilceAdi),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ilçe kodu: $veri1'),
                        Text('Nufus: $veri2'),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          );
        }
      },
    );
  }
  Future<List<Widget>> _buildExpansionTile(BuildContext context) async {
    String jsonString =
        await DefaultAssetBundle.of(context).loadString("assets/veri.json");
    List<dynamic> jsonData = json.decode(jsonString);
    List<Map<String, dynamic>> parsedData =
        jsonData.cast<Map<String, dynamic>>();
    return parsedData
        .map((e) => ListTile(title: Text(e["il_adi"].toString())))
        .toList();
  }
}