import 'package:flutter/material.dart';
import 'package:quizzapp_2/Homepage.dart';
import 'package:quizzapp_2/Question.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({Key?key}) : super(key:key);
  @override
  Widget build(BuildContext context){
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}