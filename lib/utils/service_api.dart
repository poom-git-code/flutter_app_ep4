import 'dart:convert';
import 'package:flutter_app_ep4/models/mytraveldiary.dart';
import 'package:http/http.dart' as http;

//ไฟล์นี้เอาไว้เขียนโค้ดเรียกใช้ service ต่างๆ ที่ server

//สร้างตัวแปรกลางเก็บ uel ของ server ที่เก็บ service ที่เราจะเรียกใช้
String urlService = "http://192.168.1.45:8080";

//เรียกใช้ service : serviceGetAllMyAccount.php ที่ server
Future<List<Mytraveldiary>> serviceGetAllMyTravel() async{
  //ติดต่อ service เพื่อดึงข้อมูลมาใส่ใน app
  final response = await http.get(
      Uri.encodeFull('${urlService}/traveldiary/serviceGetAllMyTravel.php'),
      headers:{"Content-Type": "application/json"}
  );

  //เอาข้อมูลในตัวแปร response มาทำการแปลงข้อมูลที่เอามาใช้ใน app
  if(response.statusCode == 200){
    //เริ่มจาก decode ข้อมูล json
    final responseData = jsonDecode(response.body);
    //decode เสร็จก็นำมาแปลงข้อมูลแบบ List เพื่อนำไปใช้งาน
    final mytraveldiaryData = await responseData.map<Mytraveldiary>((json){
      return Mytraveldiary.fromJson(json);
    }).toList();
    //สุดท้ายส่งค่ากลับไปที่จุดที่เรียกใช้เมธอดนี้เพื่อนำไปใช้งาน
    return mytraveldiaryData;
  }else{
    return null;
  }
}