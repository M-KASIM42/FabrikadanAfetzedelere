import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CompanyPage extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  CompanyPage({required this.list});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.list[index]['productname']),
                trailing: InkWell(
                  child: Icon(Icons.add),
                  onTap: () {
                    db.collection("users").doc(user.uid).set({
                      "email": user.email,
                      "FullName": "Deneme Kullanıcı", // Kullanıcının ismi
                      "user_carts": {
                        "cartnumber": 1 // Kullanıcının ilk sepet numarası
                      }
                    }).then((value) {
                      debugPrint("Kullanıcı ve sepet numarası oluşturuldu.");
                    });
                    db.collection("users").doc(user.uid).get().then((userDoc) {
                      // Kullanıcının dokümanını al
                      int cartnumber = userDoc.data()!["user_carts"][
                          "cartnumber"]; // Kullanıcının mevcut sepet numarasını al
                      int orderNumber = 1;
                      db
                          .collection("users")
                          .doc(user.uid)
                          .collection("sepet_$orderNumber")
                          .get()
                          .then((querySnapshot) {
                        orderNumber +=
                            querySnapshot.size; // Yeni sipariş numarası oluştur
                        db
                            .collection("users")
                            .doc(user.uid)
                            .collection("sepet_$cartnumber")
                            .doc("order_$orderNumber")
                            .set({
                          "productName": widget.list[index]['productname'],
                          "price": widget.list[index]['price']
                        }).then((value) {
                          debugPrint("Siparis eklendi");
                          // Sepet numarasını bir artır ve güncellemeleri Firestore'a kaydet
                          // cartnumber++;
                          // userDoc.reference.update({
                          //   "user_carts.cartnumber": cartnumber
                          // }).then((value) {
                          //   debugPrint("Sepet numarası güncellendi.");
                          // });
                        });
                      });
                    });
                  },
                ),
              );
            }),
      ),
    );
  }
}
