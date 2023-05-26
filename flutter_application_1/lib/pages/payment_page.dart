// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateMonthController =
      TextEditingController();
  final TextEditingController _expiryDateYearController =
      TextEditingController();

  final TextEditingController _cvcCodeController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  int _currentPageIndex = 0;

  List<Map<String, dynamic>> userCards = [];
  final user = FirebaseAuth.instance.currentUser!;

  void _fetchUserCards() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cards')
        .get();

    List<Map<String, dynamic>> cards = [];

    snapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        String? cardNumber = data['cardNumber'] as String?;
        String? expiryDateMonth = data['expiryDateMonth'] as String?;
        String? expiryDateYear = data['expiryDateYear'] as String?;
        String? cvcCode = data['cvcCode'] as String?;
        String? cartName = data['cartName'] as String?;

        if (cardNumber != null) {
          cards.add({
            'cardNumber': cardNumber,
            'expiryDateMonth': expiryDateMonth,
            'expiryDateYear': expiryDateYear,
            'cvcCode': cvcCode,
            'cartName':cartName
          });
        }
      }
    });

    setState(() {
      userCards = cards;
    });
  }

  void _saveCardDetails() async {

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cards')
        .add({
      'cardNumber': _cardNumberController.text,
      'expiryDateMonth': _expiryDateMonthController.text,
      'expiryDateYear': _expiryDateYearController.text,
      'cvcCode': _cvcCodeController.text,
      'cartName':_cardNameController.text
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kart Eklendi'),
          content: Text('Kartınız başarıyla eklendi.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
    _fetchUserCards();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserCards();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateMonthController.dispose();
    _cvcCodeController.dispose();
    _expiryDateYearController.dispose();
    _cardNameController.dispose();
    super.dispose();
  }

  FocusNode _yearFocusNode = FocusNode();
  FocusNode _cvcFocusNode = FocusNode();
  FocusNode _cartFocusNode = FocusNode();
  FocusNode _cartNameFocusNode = FocusNode();


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kart Bilgileri'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 400,
                height: 200,
                child: userCards.isEmpty
                    ? const Center(
                        child: Text('Kullanıcıya ait kart bulunamadı.'),
                      )
                    : PageView.builder(
                        itemCount: userCards.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 400,
                            height: 200,
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                Text(userCards[index]["cartName"]),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  userCards[index]["cardNumber"],
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                                Expanded(child: Container()),
                                Row(
                                  children: [
                                    Text("SKT  " +
                                        userCards[index]["expiryDateMonth"] + "/" + userCards[index]["expiryDateYear"]),
                                    Expanded(child: Container()),
                                    Text("CVC  " + userCards[index]["cvcCode"]),
                                    const SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          );
                        },
                        onPageChanged: (value) {
                          setState(() {
                            _currentPageIndex = value;
                          });
                        },
                      ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AnimatedSmoothIndicator(
                    activeIndex: _currentPageIndex,
                    count: userCards.length,
                    effect: const WormEffect(
                      dotHeight: 10.0,
                      dotWidth: 10.0,
                      dotColor: Colors.purple,
                      activeDotColor: Colors.black,
                    ),
                  ),
                ),
              ),
              const Text(
                'Yeni Kart Ekle',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black),
                ),
                child: TextFormField(
                  
                  onChanged: (text) {
                    if (text.isNotEmpty) {
                      if (text.length == 5 ||
                          text.length == 10 ||
                          text.length == 15) {
                        // Kullanıcı bir karakter sildiğinde, son karakter boşluk ise, otomatik olarak boşluğu sil
                        _cardNumberController.text =
                            text.substring(0, text.length - 1);
                        _cardNumberController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: _cardNumberController.text.length),
                        );
                      } else if (text.length == 4 ||
                          text.length == 9 ||
                          text.length == 14) {
                        // Kullanıcı bir karakter sildiğinde ve son karakter boşluk değilse, otomatik olarak bir boşluk ekle
                        _cardNumberController.text = text + " ";
                        _cardNumberController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: _cardNumberController.text.length),
                        );
                      }
                      else if(text.length == 19){
                        FocusScope.of(context).requestFocus(_cartFocusNode);
                      }
                    }
                  },
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Kart Numarası",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    
                    padding: EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(5)),
                    height: 50,
                    width: 75,
                    child: TextFormField(
                      focusNode: _cartFocusNode,
                      controller: _expiryDateMonthController,
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        if (text.length == 2) {
                          // Ay olarak iki karakter girildiğinde, imleci yıl alanına kaydır
                          FocusScope.of(context).requestFocus(_yearFocusNode);
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Ay',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(5)),
                    height: 50,
                    width: 75,
                    child: TextFormField(
                      onChanged: (text) {
                        if (text.length == 2) {
                          // Ay olarak iki karakter girildiğinde, imleci yıl alanına kaydır
                          FocusScope.of(context).requestFocus(_cvcFocusNode);
                        }
                      },
                      controller: _expiryDateYearController,
                      keyboardType: TextInputType.number,
                      focusNode: _yearFocusNode, // Yıl alanının focus node'u
                      decoration: const InputDecoration(
                        hintText: "Yıl",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(5)),
                    height: 50,
                    width: 75,
                    child: TextFormField(
                      onChanged: (value) {
                        if(value.length == 3){
                          FocusScope.of(context).requestFocus(_cartNameFocusNode);
                        }
                      },
                      focusNode: _cvcFocusNode,
                      controller: _cvcCodeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: "CVC",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(5)),
                height: 50,
                width: 250,
                child: TextFormField(
                  focusNode: _cartNameFocusNode,
                  controller: _cardNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      hintText: "Kartınıza isim verin",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  _saveCardDetails();
                  _cardNumberController.clear();
                  _cvcCodeController.clear();
                  _expiryDateMonthController.clear();
                  _expiryDateYearController.clear();
                  _cardNameController.clear();
                },
                child: const Text('Kart Bilgilerini Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
