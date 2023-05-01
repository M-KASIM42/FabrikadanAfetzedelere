import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ToplantiYerleri extends StatefulWidget {
  const ToplantiYerleri({Key? key}) : super(key: key);

  @override
  State<ToplantiYerleri> createState() => _ToplantiYerleriState();
}

class _ToplantiYerleriState extends State<ToplantiYerleri> {
  final CollectionReference toplantiyerleri =
      FirebaseFirestore.instance.collection('aciltoplantiyerleri');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: toplantiyerleri.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot yer = snapshot.data!.docs[index];
              return InkWell(
                onTap: () async {
                  GeoPoint point = snapshot.data!.docs[index].get('konum');
                  double latitude = point.latitude;
                  double longitude = point.longitude;
                  final String googleMapsUrl =
                      'https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}';
                  // ignore: deprecated_member_use
                  if (await canLaunch(googleMapsUrl)) {
                    // ignore: deprecated_member_use
                    await launch(googleMapsUrl);
                  } else {
                    throw 'Google Maps uygulaması açılamadı.';
                  }
                },
                child: ListTile(
                  title: Text(yer['type']),
                  subtitle: Text(yer['adres']),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          print("Veriler alınırken hata oluştu: ${snapshot.error}");
          return const Text("Bir hata oluştu.");
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
