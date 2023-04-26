import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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
      'displayName': user.displayName,
      'email': emails,
      'createdAt': 'kjchfvadbfc',
    });
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference companies =
    FirebaseFirestore.instance.collection('companies');
    return StreamBuilder<QuerySnapshot>(
          stream: companies.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    onTap: (){
                      debugPrint(company['name']);
                    },
                    child: Card(
                      
                      child: Column(
                  
                        children: [
                          Image.network(company['photo']),
                          Expanded(child: Container()),
                          Text(company['name']),
                          Text(company['phone']),
                          SizedBox(height: 25,)
                          
                        ],
                      ),
                    ),
                  );
                  // return ListTile(
                  //   title: Text(company['name']),
                  //   subtitle: Text(company['phone']),
                  //   leading: Image.network(company['photo']),
                  // );
                },
              );
            } else if (snapshot.hasError) {
              print("Veriler alınırken hata oluştu: ${snapshot.error}");
              return const Text("Bir hata oluştu.");
            } 
            else {
              return const Center(
                child: CircularProgressIndicator(
                  
                ),
              );
            }
          },
        );
  }
}