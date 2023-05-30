// ignore_for_file: prefer_interpolation_to_compose_strings, library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/pages/my_main_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

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
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  String selectedCard = "";
  bool isLoading = false;

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
            'cartName': cartName
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
      'cartName': _cardNameController.text
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
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/contact_less.png",
                                      height: 30,
                                    ),
                                    Expanded(child: Container()),
                                    Image.asset(
                                      "assets/mastercard.png",
                                      height: 60,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  userCards[index]["cartName"],
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "**** **** **** " +
                                      userCards[index]["cardNumber"].substring(
                                          userCards[index]["cardNumber"]
                                                  .length -
                                              4),
                                  // userCards[index]["cardNumber"].toString().substring(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("SKK"),
                                        Text(userCards[index]
                                                ["expiryDateMonth"] +
                                            "/" +
                                            userCards[index]["expiryDateYear"])
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("CVC"),
                                        Text(userCards[index]["cvcCode"])
                                      ],
                                    )
                                  ],
                                ),
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
                      } else if (text.length == 19) {
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
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5)),
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
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5)),
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
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5)),
                    height: 50,
                    width: 75,
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.length == 3) {
                          FocusScope.of(context)
                              .requestFocus(_cartNameFocusNode);
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
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5)),
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
              SizedBox(
                height: 20,
              ),
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
              ExpansionTile(
                title: selectedCard.isEmpty
                    ? const Text("Kartlarım")
                    : Text(selectedCard),
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: userCards.length,
                    itemBuilder: (context, index) {
                      var cardInfo = userCards[index];
                      String cardName = cardInfo['cartName'];
                      String cardNumber = cardInfo['cardNumber'];
                      String maskedCardNumber = "**** **** **** " +
                          cardNumber.substring(cardNumber.length - 4);
                      // Diğer kart bilgilerini burada alabilirsiniz

                      return ListTile(
                        onTap: () {
                          setState(() {
                            selectedCard = cardName;
                          });
                        },

                        title: Row(
                          children: [
                            Text(cardName),
                            Expanded(child: Container()),
                            Text(maskedCardNumber)
                          ],
                        ),
                        // Diğer kart bilgilerini burada gösterebilirsiniz
                      );
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedCard.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        isLoading = false;
                      });
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Ödeme Yapıldı'),
                          content: Text('Ödeme işlemi başarıyla tamamlandı.'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                var sepetCollection = db
                                    .collection("users")
                                    .doc(user.uid)
                                    .collection("sepet_1");
                                QuerySnapshot snapshot =
                                    await sepetCollection.get();

                                var yeniKoleksiyon = db
                                    .collection("users")
                                    .doc(user.uid)
                                    .collection("yeni_sepet");

                                for (DocumentSnapshot doc in snapshot.docs) {
                                  // Veriyi yeni koleksiyona kaydedin
                                  await yeniKoleksiyon.add(
                                      Map<String, dynamic>.from(
                                          doc.data() as Map<String, dynamic>));

                                  // İlgili belgeyi eski koleksiyondan silin
                                  await doc.reference.delete();
                                  Navigator.push(context, MaterialPageRoute(builder: (mymainpage)=>MyMainPage()));
                                }
                              },
                              child: const Text('Tamam'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Kart Seçiniz"),
                          content: Text("Lütfen bir kart seçin."),
                          actions: [
                            ElevatedButton(
                              child: Text("İptal"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              child: Text("Tamam"),
                              onPressed: () {
                                // Kart seçimi tamamlandığında yapılacak işlemler
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ))
                    : Text('Ödeme Yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
