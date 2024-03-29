// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/torku_page.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  late String emails;

  Future<void> init() async {
    final user = FirebaseAuth.instance.currentUser!;
    emails = user.email!;
    final db = FirebaseFirestore.instance.collection('users');

    await db.doc(user.uid).set({
      "email": user.email,
      "FullName": "Deneme Kullanıcı", // Kullanıcının ismi
      "user_carts": {
        "cartnumber": 1 // Kullanıcının ilk sepet numarası
      }
    }).then((value) {
      debugPrint("Kullanıcı ve sepet numarası oluşturuldu.");
    });
    
  }
  @override
  void initState() {
    super.initState();
    init();
  }
  @override
  Widget build(BuildContext context) {
    final CollectionReference companies =
        FirebaseFirestore.instance.collection('companies');
    return StreamBuilder<QuerySnapshot>(
      stream: companies.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Sütun sayısını belirttik
              mainAxisSpacing: 10.0, // Dikey boşluk
              crossAxisSpacing: 10.0, // Yatay boşluk
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot company = snapshot.data!.docs[index];
              return InkWell(
                onTap: () async {
                  List<Map<String, dynamic>> temp =
                      await getProducts(company['id']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyPage(
                                list: temp,
                              )));
                },
                child: Card(
                  child: Column(
                    children: [
                      Image.network(company['photo'],height: 100),
                      Expanded(child: Container()),
                      Text(company['name']),
                      Text(company['phone']),
                      SizedBox(
                        height: 25,
                      )
                    ],
                  ),
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

  Future<List<Map<String, dynamic>>> getProducts(String companyId) async {
    DocumentReference companyRef =
        FirebaseFirestore.instance.collection('companies').doc(companyId);
    CollectionReference products = companyRef.collection('products');
    QuerySnapshot productSnapshot = await products.get();
    List<Map<String, dynamic>> mylist = [];
    for (QueryDocumentSnapshot product in productSnapshot.docs) {
      mylist.add({
        'productname': product['productname'],
        'price': product['price'],
        'photo': product['photo'],
        'oldprice':product["oldprice"]
      });
    }
    return mylist;
    // for (var element in mylist) {
    //   print(element.values);

    // }
  }

  _getProducts(List<Map<String, dynamic>> list) {
    return Container(
      child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              title: list[index]['productname'],
            );
          }),
    );
  }
}
