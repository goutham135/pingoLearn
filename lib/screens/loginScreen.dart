import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/authServices.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLogin = true;
  var errorMessage = StateProvider((ref) => '');
  signIn() async {
    if(email.text.isEmpty){
      ref.read(errorMessage.notifier).state = 'Please enter the email';
    } else if(password.text.isEmpty){
      ref.read(errorMessage.notifier).state = 'Please enter the password';
    } else if(email.text.isNotEmpty && !RegExp(emailReg).hasMatch(email.text)){
      ref.read(errorMessage.notifier).state = 'Please enter the valid email';
    } else{
      try {
        await Auth().signInWithEmailAmdPassword(email: email.text, password: password.text);
      } on FirebaseAuthException catch (e){
        ref.read(errorMessage.notifier).state = e.message!;
      }
    }
  }

  createUser() async {
    if(name.text.isEmpty){
      ref.read(errorMessage.notifier).state = 'Please enter the name';
    } else if(email.text.isEmpty){
      ref.read(errorMessage.notifier).state = 'Please enter the email';
    } else if(password.text.isEmpty){
      ref.read(errorMessage.notifier).state = 'Please enter the password';
    } else if(email.text.isNotEmpty && !RegExp(emailReg).hasMatch(email.text)){
      ref.read(errorMessage.notifier).state = 'Please enter the valid email';
    } else{
      ref.read(errorMessage.notifier).state = '';
      var userDetails = {
        'name' : name.text,
        'email' : email.text,
      };
      FirebaseFirestore.instance.collection('user_details').add(userDetails);
      try {
        await Auth().createUserWithEmailAndPassword(email: email.text, password: password.text);
      } on FirebaseAuthException catch (e){
        ref.read(errorMessage.notifier).state = e.message!;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    var _errorMessage = ref.watch(errorMessage);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFFedfafc),
          statusBarIconBrightness: Brightness.dark,
        ),
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: getHeight(context)/15, horizontal: getWidth(context)/20),
            height: getHeight(context)/1.01,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Comments', style: TextStyle(fontSize: 22, color: primaryColor, fontWeight: FontWeight.w900),),
                Column(
                  children: [
                    if(!isLogin)MyTextBox(controller: name, hintText: 'Name'),
                    if(!isLogin)const SizedBox(height: 10,),
                    MyTextBox(controller: email, hintText: 'Email'),
                    const SizedBox(height: 10,),
                    MyTextBox(controller: password, obscureText: true, hintText: 'Password'),
                    const SizedBox(height: 10,),
                    Text(_errorMessage, style: TextStyle(color: Colors.red, fontSize: 12),),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        isLogin ? signIn() : createUser();
                      },
                      child: MyButton(text: isLogin ? 'Login' : 'Signup',)
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isLogin ? 'New here? ' : 'Already have an account? '),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(isLogin ? 'Signup' : 'Login', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),)
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
