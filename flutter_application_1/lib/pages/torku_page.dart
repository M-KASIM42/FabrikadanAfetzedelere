import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanyPage extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  CompanyPage({required this.list});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  int cartNumber = 1;

  @override
  void initState() {
    super.initState();
    db.collection("users").doc(user.uid).get().then((userDoc) =>
        {cartNumber = userDoc.data()!["user_carts"]["cartnumber"]});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.list[index]['productname']),
                subtitle: Text(widget.list[index]["price"] + "     TL"),
                trailing: InkWell(
                    child: Icon(Icons.add),
                    onTap: () {
                      db
                          .collection("users")
                          .doc(user.uid)
                          .collection("sepet_$cartNumber")
                          .get()
                          .then((querySnapshot) {
                        bool productAlreadyInCart = false;
                        String productName = widget.list[index]['productname'];

                        querySnapshot.docs.forEach((doc) {
                          if (doc.data()['productName'] == productName) {
                            productAlreadyInCart = true;
                            int currentQuantity = doc.data()['quantity'];
                            int newQuantity = currentQuantity + 1;

                            // Belgenin quantity alanını güncelle
                            db
                                .collection("users")
                                .doc(user.uid)
                                .collection("sepet_$cartNumber")
                                .doc(doc.id)
                                .update({"quantity": newQuantity}).then(
                                    (value) {
                              debugPrint("Quantity artırıldı.");
                            }).catchError((error) {
                              debugPrint("Quantity artırma hatası: $error");
                            });

                            return;
                          }
                        });

                        if (!productAlreadyInCart) {
                          // Ürün sepette değilse, sepete ekleme işlemini burada gerçekleştir
                          int orderNumber = querySnapshot.size + 1;
                          db
                              .collection("users")
                              .doc(user.uid)
                              .collection("sepet_$cartNumber")
                              .doc("order_$orderNumber")
                              .set({
                            "productName": widget.list[index]['productname'],
                            "price": widget.list[index]['price'],
                            "quantity": 1
                          }).then((value) {
                            debugPrint("Sipariş eklendi");
                          });
                        }
                      });
                    }),
              );
            }),
      ),
    );
  }
}
                            // cartnumber++;
                            // userDoc.reference.update({
                            //   "user_carts.cartnumber": cartnumber
                            // }).then((value) {
                            //   debugPrint("Sepet numarası güncellendi.");
                            // });