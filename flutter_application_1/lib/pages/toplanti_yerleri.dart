import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'konum_page.dart';

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
                onTap: () {
                  GeoPoint point = snapshot.data!.docs[index].get('konum');
                  double latitude = point.latitude;
                  double longitude = point.longitude;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            KonumPage(lat: latitude, long: longitude),
                      ));
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
