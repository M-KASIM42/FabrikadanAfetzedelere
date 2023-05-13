import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  int cartNumber = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db.collection("users").doc(user!.uid).get().then((userDoc) => {
      cartNumber = userDoc.data()!["user_carts"][
                          "cartnumber"]
    } );
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      color: Colors.yellowAccent,
      child: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection("users")
            .doc(user!.uid)
            .collection("sepet_$cartNumber")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Bir şeyler yanlış gitti');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Yükleniyor...");
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data!.docs[index];
              return ListTile(
                title: Text(data['productName']),
                subtitle: Text(data['price'].toString()),
              );
            },
          );
        },
      ),
    );
  }
}
