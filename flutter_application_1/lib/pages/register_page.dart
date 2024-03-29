// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Birlikte",
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            "Yardım",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (_passwordController.text.trim() !=
                      _rePasswordController.text.trim()) {
                    return 'Parolalar uyuşmuyor';
                  } else {
                    return null;
                  }
                },
                obscureText: true,
                controller: _rePasswordController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'RePassword',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              String email = _emailController.text.trim();
              String password = _passwordController.text.trim();
              String rePassword = _rePasswordController.text.trim();

              if (password == rePassword) {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Kayıt Başarılı"),
                        content: Text(
                            "Kayıt işlemi tamamlandı. E-posta adresinizi doğrulamak için bir doğrulama bağlantısı gönderildi."),
                      );
                    },
                  );

                  // E-posta doğrulama e-postası gönderme
                  User? user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();

                  Future.delayed(Duration(seconds: 2));

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (loginpage) => LoginPage()),
                  );
                } catch (error) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Hata"),
                        content: Text(error.toString()),
                      );
                    },
                  );
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.green,
              ),
              width: 340,
              height: 50,
              child: Center(
                child: Text(
                  "Kayıt Ol",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
