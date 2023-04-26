// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'cart_page.dart';
import 'my_account_page.dart';
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
    MyAccountPage(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Fabrikadan Afetzedelere"),
        ),
        drawer: Drawer(
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
                    )
                  ],
                ),
              )
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
              icon: Icon(Icons.account_circle),
              label: 'Hesabım',
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
