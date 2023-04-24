import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String emails;

  @override
  void initState() {
    super.initState();
    init();
  }

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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  final userData = snapshot.data!;
                  return Column(
                    children: [
                      Text('Display Name: ${userData['displayName']}'),
                      Text('Email: ${userData['email']}'),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("Bir hata oluştu: ${snapshot.error}");
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            Text('Hoşgeldiniz, $emails'),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text('Çıkış'),
            ),
          ],
        ),
      ),
    );
  }
}
