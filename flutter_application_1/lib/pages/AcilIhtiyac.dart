import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/talep_girisi.dart';

class AcilIhtiyac extends StatefulWidget {
  @override
  _AcilIhtiyacState createState() => _AcilIhtiyacState();
}

class _AcilIhtiyacState extends State<AcilIhtiyac> {
  TextEditingController _searchController1 = TextEditingController();
  TextEditingController _searchController2 = TextEditingController();
  List<QueryDocumentSnapshot> _searchResults = [];

  void _searchData(String searchText) {
    FirebaseFirestore.instance
        .collection('AcilIhtiyaclar')
        .where('il', isGreaterThanOrEqualTo: searchText)
        .where('il', isLessThan: searchText + 'z')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _searchResults = querySnapshot.docs;
      });
    });
  }

  void _searchDataa(String searchText) {
    FirebaseFirestore.instance
        .collection('AcilIhtiyaclar')
        .where('ilce', isGreaterThanOrEqualTo: searchText)
        .where('ilce', isLessThan: searchText + 'z')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _searchResults = querySnapshot.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TalepGirisi()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController1,
              onChanged: (value) {
                _searchData(value);
              },
              decoration: InputDecoration(
                labelText: 'İl Giriniz',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController2,
              onChanged: (value) {
                _searchDataa(value);
              },
              decoration: InputDecoration(
                labelText: 'İlçe Giriniz',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]["adrestarifi"]),
                  subtitle: Text(_searchResults[index]["talep"]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
