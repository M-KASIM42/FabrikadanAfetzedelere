import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/payment_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  int toplamTutar = 0;
  int orderNumber = 1;
  @override
  void initState() {
    super.initState();
    db
        .collection("users")
        .doc(user!.uid)
        .collection("sepet_1")
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
                .collection("sepet_1")
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
                    height: 200,
                    margin: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(
                            data["photo"],
                            height: 200,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Column(
                            children: [
                              SizedBox(height: 50,),
                              Text(
                                data["productName"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              SizedBox(height: 25,),
                              Text(data['price'] + "   TL",style: TextStyle(color: Colors.deepOrangeAccent,fontSize: 15,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            width: 65,
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  int newQuantity;
                                  if (value.isEmpty) {
                                    newQuantity = 0;
                                  } else {
                                    newQuantity = int.parse(value);
                                  }
                                  db
                                      .collection("users")
                                      .doc(user!.uid)
                                      .collection("sepet_1")
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
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                child: buildCartTotal(context, user!.uid)))
      ],
    );
  }

  Widget buildCartTotal(BuildContext context, String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('sepet_1')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Sepet Boş',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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

          return GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (paymentpage) => PaymentPage())),
            child: Center(
              child: Text(
                'Sepet Toplamı: $totalPrice',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Veriler alınırken bir hata oluştu.');
        }

        return const Center(
          child: Text("Sepet Yükleniyor"),
        );
      },
    );
  }
}
