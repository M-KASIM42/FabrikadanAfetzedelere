import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/pages/talep_girisi.dart';

class AcilIhtiyac extends StatefulWidget {
  const AcilIhtiyac({super.key});

  @override
  State<AcilIhtiyac> createState() => _AcilIhtiyacState();
}

class _AcilIhtiyacState extends State<AcilIhtiyac> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _acilIhtiyaclarRef =
      FirebaseFirestore.instance.collection('AcilIhtiyaclar');
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      StreamBuilder<QuerySnapshot>(
        stream: _acilIhtiyaclarRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> veri = document.data() as Map<String, dynamic>;
              String fullname = veri['fullname'];
              String il = veri['il'];
              String ilce = veri['ilce'];

              return ListTile(
                title: Text('Ad: $fullname'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('İhtiyaç: $il'),
                    Text('Miktar: $ilce'),
                  ],
                ),
              );
            }).toList(),
          );
        },),
      Positioned(
        bottom: 20,
        right: 20,
        child: FloatingActionButton(
          child: const Icon(Icons.add,color: Colors.white),
          onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (talep)=>TalepGirisi()));
        }),
      )
    ]);
  }
}