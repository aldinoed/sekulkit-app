import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget textField(String title, TextEditingController controller, bool isNumber) {

  return TextField(

    controller: controller,
    obscureText: title == 'Password' ? true : false,
    keyboardType: isNumber? TextInputType.number : TextInputType.text,
    decoration: InputDecoration(
      label: Text(title),
      enabledBorder: OutlineInputBorder(
          borderSide:
          const BorderSide(color: Colors.deepPurpleAccent),
          borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),),
  );
}