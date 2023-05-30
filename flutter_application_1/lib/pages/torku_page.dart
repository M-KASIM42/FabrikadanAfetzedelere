import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/product_page.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Sütun sayısını belirttik
            mainAxisSpacing: 10.0, // Dikey boşluk
            crossAxisSpacing: 10.0, // Yatay boşluk
            childAspectRatio: 0.65),
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 10),
            height: 150,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(widget.list[index]["photo"]),
                      ),
                    ),
                    width: 150,
                    height: 150,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (productPage) =>
                                ProductPage(url: widget.list[index]["photo"])));
                  },
                ),
                Text(widget.list[index]['productname']),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.list[index]["oldprice"] + " TL",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration
                            .lineThrough, // Kırmızı çizgi eklemek için
                        decorationColor: Colors.redAccent, // Çizgi rengi
                        decorationThickness: 2.0, // Çizgi kalınlığı
                      ),
                    ),
                    Text("    yerine"),
                    Text(widget.list[index]['price'] + " TL",style: TextStyle(
                      fontSize: 20,fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    db
                        .collection("users")
                        .doc(user.uid)
                        .collection("sepet_1")
                        .get()
                        .then(
                      (querySnapshot) {
                        bool productAlreadyInCart = false;
                        String productName = widget.list[index]['productname'];

                        querySnapshot.docs.forEach(
                          (doc) {
                            if (doc.data()['productName'] == productName) {
                              productAlreadyInCart = true;
                              int currentQuantity = doc.data()['quantity'];
                              int newQuantity = currentQuantity + 1;

                              // Belgenin quantity alanını güncelle
                              db
                                  .collection("users")
                                  .doc(user.uid)
                                  .collection("sepet_1")
                                  .doc(doc.id)
                                  .update({"quantity": newQuantity}).then(
                                (value) {
                                  debugPrint("Quantity artırıldı.");
                                },
                              ).catchError(
                                (error) {
                                  debugPrint("Quantity artırma hatası: $error");
                                },
                              );

                              return;
                            }
                          },
                        );

                        if (!productAlreadyInCart) {
                          // Ürün sepette değilse, sepete ekleme işlemini burada gerçekleştir
                          int orderNumber = querySnapshot.size + 1;
                          db
                              .collection("users")
                              .doc(user.uid)
                              .collection("sepet_1")
                              .doc("order_$orderNumber")
                              .set(
                            {
                              "productName": widget.list[index]['productname'],
                              "price": widget.list[index]['price'],
                              "quantity": 1,
                              "photo": widget.list[index]["photo"]
                            },
                          ).then(
                            (value) {
                              debugPrint("Sipariş eklendi");
                            },
                          );
                        }
                      },
                    );
                  },
                  child: const Text("Sepete Ekle"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
