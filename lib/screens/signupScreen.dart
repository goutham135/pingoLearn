import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helper.dart';
import '../services/authServices.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String errorMessage = '';


  createUser() async {
    try {
      await Auth().createUserWithEmailAndPassword(email: email.text, password: password.text);
    } on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message!;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFFedfafc),
          statusBarIconBrightness: Brightness.dark,
        ),
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            children: [
              const Text('Comments', style: TextStyle(fontSize: 14, color: CupertinoColors.activeBlue),),
              Column(
                children: [
                  MyTextBox(controller: email, hintText: 'Username',),
                  const SizedBox(height: 10,),
                  MyTextBox(controller: email, hintText: 'Email',),
                  const SizedBox(height: 10,),
                  MyTextBox(controller: password, obscureText: true, hintText: 'Password',),
                ],
              ),
              Column(
                children: [
                  MyButton(text: 'Signup',),
                  const Row(
                    children: [
                      Text('Already have an account?'),
                      Text('Login', style: TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.w500),)
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
