import 'package:flutter/material.dart';
import 'dart:convert';

class DenemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpansionTile Örneği',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('ExpansionTile Örneği'),
        ),
        body: FutureBuilder<List<Widget>>(
          future: _buildExpansionTile(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Hata: ${snapshot.error}');
            } else {
              return ListView(
                children: [
                  ExpansionTile(
                    title: Text("Şehir Seçiniz"),
                    children: snapshot.data ?? [],
                  ),
                ],
              );
            }
          },
        ),
      ),
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
