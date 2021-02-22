import 'package:flutter/material.dart';
import 'package:flutter_app_ep4/views/home_ui.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeUi(),
      theme: ThemeData(
          primaryColor: Color(0xffF7C289)
      ),
    )
  );
}