import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  int cartNumber = 1;
  int toplamTutar = 0;
  int orderNumber = 1;
  @override
  void initState() {
    super.initState();
    db.collection("users").doc(user!.uid).get().then((userDoc) =>
        {cartNumber = userDoc.data()!["user_carts"]["cartnumber"]});
    db
        .collection("users")
        .doc(user!.uid)
        .collection("sepet_$cartNumber")
        .get()
        .then((querySnapshot) {
      orderNumber = querySnapshot.size + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot>(
            stream: db
                .collection("users")
                .doc(user!.uid)
                .collection("sepet_$cartNumber")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Bir şeyler yanlış gitti');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.greenAccent,
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data!.docs[index];
                  return Container(
                    width: double.infinity,
                    height: 42,
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          color: Colors.pink,
                          child: Column(
                            children: [
                              Text(data["productName"]),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(data['price'] + "   TL")
                            ],
                          ),
                        ),
                        Form(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(),
                              onChanged: (value) {
                                // Girilen değeri quantity'ye atama
                                int newQuantity;
                                if (value.isEmpty) {
                                  newQuantity = 0;
                                } else {
                                  newQuantity = int.parse(value);
                                } // Girilen değeri integer'a dönüştür

                                // quantity alanını güncelle

                                db
                                    .collection("users")
                                    .doc(user!.uid)
                                    .collection("sepet_$cartNumber")
                                    .doc("order_${index + 1}")
                                    .update({"quantity": newQuantity}).then(
                                        (value) {
                                  debugPrint(
                                      "Quantity güncellendi: $newQuantity");
                                }).catchError((error) {
                                  debugPrint(
                                      "Quantity güncelleme hatası: $error");
                                });
                              },
                              initialValue: data["quantity"].toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
                color: Colors.amber[900],
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child:
                    buildCartTotal(context, user!.uid, cartNumber.toString())))
      ],
    );
  }

  Widget buildCartTotal(
      BuildContext context, String userId, String cartNumber) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('sepet_$cartNumber')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return const Text(
              'Sepet Boş',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            );
          }
          int totalPrice = 0;

          snapshot.data!.docs.forEach((doc) {
            String price = (doc.data() as Map<String, dynamic>)['price'] ?? 0;
            int quantity =
                (doc.data() as Map<String, dynamic>)['quantity'] ?? 0;

            int subtotal = int.parse(price) * quantity;

            totalPrice += subtotal;
          });

          return Text(
            'Sepet Toplamı: $totalPrice',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          );
        } else if (snapshot.hasError) {
          return Text('Veriler alınırken bir hata oluştu.');
        }

        return CircularProgressIndicator();
      },
    );
  }
}
