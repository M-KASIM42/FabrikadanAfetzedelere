import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DenemePage extends StatelessWidget {

  DenemePage({super.key, });
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Information'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var cardInfo = snapshot.data!['cards'];

          return ListView(
            children: <Widget>[
              ExpansionTile(
                title: Text('Card Information'),
                children: <Widget>[
                  ListTile(
                    title: Text('Card Number'),
                    subtitle: Text(cardInfo['cardNumber']),
                  ),
                  
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
