// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class ToplantiYerleri extends StatefulWidget {
  const ToplantiYerleri({Key? key}) : super(key: key);

  @override
  State<ToplantiYerleri> createState() => _ToplantiYerleriState();
}

class _ToplantiYerleriState extends State<ToplantiYerleri> with SingleTickerProviderStateMixin{
  final CollectionReference toplantiyerleri =
      FirebaseFirestore.instance.collection('aciltoplantiyerleri');
  final CollectionReference yardimyerleri =
      FirebaseFirestore.instance.collection('acilyardimyerleri');

  Future<void> requestLocationPermissions() async {
    final permissions = await Permission.location.request();
    if (permissions.isGranted) {
      // izin verildi
    } else if (permissions.isDenied) {
      // izin reddedildi, kullanıcıya açıklama yapın
      await openAppSettings();
    } else if (permissions.isPermanentlyDenied) {
      // izin kalıcı olarak reddedildi, kullanıcıyı ayarlara yönlendirin
      await openAppSettings();
    }
  }
TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        title: Text("",style: TextStyle(fontSize: 1),),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Acil Toplanma Alanları'),
            Tab(text: 'Acil Yardım Alma Alanları'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Veri 1'e ait içerik
          Center(
                child: StreamBuilder<QuerySnapshot>(
                  stream: toplantiyerleri.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot yer = snapshot.data!.docs[index];
                          return InkWell(
                            onTap: () async {
                              await requestLocationPermissions();
                              GeoPoint point =
                                  snapshot.data!.docs[index].get('konum');
                              double latitude = point.latitude;
                              double longitude = point.longitude;
                              final String googleMapsUrl =
                                  'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
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
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
          // Veri 2'ye ait içerik
          Center(
                child: StreamBuilder<QuerySnapshot>(
                  stream: yardimyerleri.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot yer = snapshot.data!.docs[index];
                          return InkWell(
                            onTap: () async {
                              await requestLocationPermissions();
                              GeoPoint point =
                                  snapshot.data!.docs[index].get('konum');
                              double latitude = point.latitude;
                              double longitude = point.longitude;
                              final String googleMapsUrl =
                                  'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
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
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
        ],
      ),);
  }
}
