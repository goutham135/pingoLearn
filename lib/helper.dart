import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color primaryColor = const Color(0xFF2571B8);

class MyTextBox extends StatelessWidget {
  TextEditingController controller;
  bool obscureText;
  String hintText;
  MyTextBox({super.key, required this.controller, this.obscureText = false, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black, fontSize: 12),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}


class MyButton extends StatelessWidget {
  String text;
  MyButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context)/2,
      height: getHeight(context)/15,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(child: Text(text, style: const TextStyle(fontSize: 18,color: Colors.white, fontWeight: FontWeight.w900),)),
    );
  }
}


getWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}

getHeight(BuildContext context){
  return MediaQuery.of(context).size.height;
}

var emailReg = r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

enum ApiStatus{
  stable,
  loading,
  success,
  networkError,
  error,
  noData,
}

class MyLoader extends StatelessWidget {
  const MyLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(context),
      width: getWidth(context),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.black,),
      ),
    );
  }
}

class MyNoData extends StatelessWidget {
  const MyNoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(context),
      width: getWidth(context),
      child: const Center(
        child: Text('No comments found.', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}

class MyNetworkError extends StatelessWidget {
  const MyNetworkError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(context),
      width: getWidth(context),
      child: const Center(
        child: Text('Network not found.', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}

class MyError extends StatelessWidget {
  const MyError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(context),
      width: getWidth(context),
      child: const Center(
        child: Text('Some error occurred.', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}

