import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController1 = TextEditingController();
  TextEditingController _searchController2 = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];

  void _searchData(String searchText) {
    FirebaseFirestore.instance
        .collection('AcilIhtiyaclar') // Verilerinizi tuttuğunuz koleksiyon adı
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
        .collection('AcilIhtiyaclar') // Verilerinizi tuttuğunuz koleksiyon adı
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
  void dispose() {
    _searchController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veri Arama'),
      ),
      body: Column(
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
                // Verilerinizi burada listeleyebilirsiniz
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
