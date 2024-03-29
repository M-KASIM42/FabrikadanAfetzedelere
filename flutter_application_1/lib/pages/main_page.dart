// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/toplanti_yerleri.dart';

import 'cart_page.dart';
import 'AcilIhtiyac.dart';
import 'my_main_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List pages = [
    MyMainPage(),
    CartPage(),
    AcilIhtiyac(),
    ToplantiYerleri()
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Birlikte Yardım"),
        ),
        drawer: Drawer(
          width: 250,
          backgroundColor: Colors.white,
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey.shade500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("E-Mail"),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(FirebaseAuth.instance.currentUser!.email!)
                        ],
                      )),
                ],
              ),
              Container(
                color: Colors.white.withOpacity(0.4),
                child: Column(
                  children: [
                    GestureDetector(
                      child: const ListTile(
                        title: Text("Hesabım"),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    GestureDetector(
                      onTap: () {},
                      child: const ListTile(
                        title: Text("Ayarlar"),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    GestureDetector(
                      child: const ListTile(
                        title: Text("Çıkış Yap"),
                      ),
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                      },
                    ),
                    
                  ],
                ),
              ),
              Expanded(child: Container()),
              Text("support_birlikteyardim@gmail.com",style: TextStyle(color: Colors.blueAccent),),
              SizedBox(height: 10,)

            ],
          ),
        ),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Anasayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Sepet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.live_help),
              label: 'Acil İhtiyaç',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Toplantı Yerleri',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
