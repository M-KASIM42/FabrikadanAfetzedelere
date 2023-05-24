// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/forgot_password.dart';
import 'package:flutter_application_1/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Birlikte",
              style: TextStyle(
                  color: Colors.deepOrangeAccent[200],
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Yardım",
              style: TextStyle(
                color: Colors.deepOrangeAccent[200],
                fontSize: 40,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
              ),
            ),
            
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Row(
                
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                    },
                    child: Text("Forgot Password",style: TextStyle(color: Colors.blue),),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () async {
              try {
                 await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());

              } catch (e) {
                showDialog(context: context, builder: (context){
                  return AlertDialog(content: Text(e.toString()),);
                });
              }
            }, 
            child: Text("Giriş Yap"),),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hesabın yok mu "),
                TextButton(child: Text("Kayıt Ol"),onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (RegisterContex)=> RegisterPage()));
                },)
              ],
            )
          ],
        ),
      ),
    );
  }
}
