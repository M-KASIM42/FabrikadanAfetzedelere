import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class TalepGirisi extends StatefulWidget {
  const TalepGirisi({Key? key}) : super(key: key);

  @override
  _TalepGirisiState createState() => _TalepGirisiState();
}

class _TalepGirisiState extends State<TalepGirisi> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ilceController = TextEditingController();
  final _adresTarifiController = TextEditingController();
  final _talepController = TextEditingController();

  String selectedCity = '';
  String selectedDistrict = '';
  List<Map<String, dynamic>> list = [];

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _ilceController.dispose();
    _adresTarifiController.dispose();
    _talepController.dispose();
    super.dispose();
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> veriEkle() {
    CollectionReference acilIhtiyaclarRef = _firestore.collection('AcilIhtiyaclar');

    Map<String, dynamic> yeniIhtiyac = {
      'adrestarifi': _adresTarifiController.text,
      'aciliyet': '3',
      'fullname': _fullNameController.text,
      'il':selectedCity.toUpperCase(),
      'ilce':selectedDistrict.toUpperCase(),
      'phone':_phoneController.text,
      'talep':_talepController.text
    };

    return acilIhtiyaclarRef.add(yeniIhtiyac)
        .then((value) => print('Veri eklendi. Doküman ID: ${value.id}'))
        .catchError((error) => print('Veri ekleme hatası: $error'));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              Text("Bilgilerinizi Eksiksiz bir şekilde giriniz",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              _buildContainer("İsim Soyisim", _fullNameController,20,1,TextInputType.name),
              _buildContainer("Numara (555) 555 5555", _phoneController,10,1,TextInputType.phone),
              _buildCityExpansionTile(),
              _buildDistrictsExpansionTile(list),
              _buildContainer("Adres Tarifi", _adresTarifiController,100,3,TextInputType.streetAddress),
              _buildContainer("İhtiyaç talebinizi buraya yazabilirsiniz", _talepController,100,3,TextInputType.text),
              ElevatedButton(onPressed: (){
                veriEkle();
                Navigator.pop(context);
              }, child: Text("Onayla"))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(String hintText, TextEditingController controller,int maxlenght,int maxline,TextInputType type) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: TextFormField(
        
        keyboardType: type,
        maxLength: maxlenght,
        maxLines: maxline,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          hintText: hintText,
          
        ),
      ),
    );
  }

  Widget _buildCityExpansionTile() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.black)
      ),
      child: FutureBuilder<List<Widget>>(
        future: _buildExpansionTileContent(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          } else {
            return ExpansionTile(
              title:
                  Text(selectedCity.isEmpty ? "Şehir Seçiniz" : selectedCity),
              children: snapshot.data ?? [],
              onExpansionChanged: (expanded) {
                if (!expanded) {
                  setState(() {
                    selectedCity = '';
                  });
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Widget>> _buildExpansionTileContent(BuildContext context) async {
    String jsonString =
        await DefaultAssetBundle.of(context).loadString("assets/veri.json");
    List<dynamic> jsonData = json.decode(jsonString);
    List<Map<String, dynamic>> parsedData =
        jsonData.cast<Map<String, dynamic>>();

    return parsedData.map((e) {
      List<Map<String, dynamic>> ilceler =
          (e['ilceler'] as List).cast<Map<String, dynamic>>();
      return ListTile(
        title: Text(e["il_adi"].toString()),
        onTap: () {
          setState(() {
            selectedCity = e["il_adi"].toString();
            selectedDistrict = "";
            list = ilceler;
          });
        },
      );
    }).toList();
  }

  Widget _buildDistrictsExpansionTile(List<Map<String, dynamic>> districts) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: ExpansionTile(
        title: Text(selectedDistrict.isEmpty ? "İlçe Seçiniz" : selectedDistrict),
        children: districts.map((district) {
          return ListTile(
            title: Text(district['ilce_adi'].toString()),
            onTap: () {
              setState(() {
                selectedDistrict = district['ilce_adi'].toString();
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
