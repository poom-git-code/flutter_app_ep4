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

//สร้างเมธอดเรียนกใช้ Service : serviceInsertMyAccount
Future<String> serviceInsertTravelDiary(String tState, String tImage, String tNum, String tDay,String tPay, String imageName) async{
  //นำค่าที่จะส่งไปบันทึกที่ Server มารวมกันเป็นออฟเจ็กต์
  Mytraveldiary mytraveldiary = Mytraveldiary(
      tState: tState,
      tImage: tImage,
      tNum: tNum,
      tDay: tDay,
      tPay: tPay,
      imageName: imageName
  );

  //ส่งข้อมูลไป Server ผ่าน Service insert
  final response = await http.post(
      Uri.encodeFull('${urlService}/traveldiary/serviceInsertTravelDiary.php'),
      body: json.encode(mytraveldiary.toJson()),
      headers: {"Content-Type": "application/json"}
  );

  //เอาทผลี่ส่งกลับมาส่งกลับไปยังจุดเรียกใช้เพื่อนำข้อมูลที่ส่งกลับมาไปใช้งาน
  if(response.statusCode == 201){
    final resData = json.decode(response.body);
    return resData['message'];
  }
  else{
    return null;
  }
}

Future<String> serviceUpDateTravelDiary(String tID, String tState, String tImage, String tNum, String tDay,String tPay, String imageName) async{
  //นำค่าที่จะส่งไปบันทึกที่ Server มารวมกันเป็นออฟเจ็กต์
  Mytraveldiary mytraveldiary = Mytraveldiary(
      tId: tID,
      tState: tState,
      tImage: tImage,
      tNum: tNum,
      tDay: tDay,
      tPay: tPay,
      imageName: imageName
  );

  //ส่งข้อมูลไป Server ผ่าน Service insert
  final response = await http.post(
      Uri.encodeFull('${urlService}/traveldiary/serviceUpDateTravelDiary.php'),
      body: json.encode(mytraveldiary.toJson()),
      headers: {"Content-Type": "application/json"}
  );

  //เอาทผลี่ส่งกลับมาส่งกลับไปยังจุดเรียกใช้เพื่อนำข้อมูลที่ส่งกลับมาไปใช้งาน
  if(response.statusCode == 201){
    final resData = json.decode(response.body);
    return resData['message'];
  }
  else{
    return null;
  }
}

Future<String> serviceDeleteMyTravel(String tId) async{
  //นำค่าที่จะส่งไปบันทึกที่ Server มารวมกันเป็นออฟเจ็กต์
  Mytraveldiary mytraveldiary = Mytraveldiary(
    tId: tId
  );

  //ส่งข้อมูลไป Server ผ่าน Service insert
  final response = await http.post(
      Uri.encodeFull('${urlService}/traveldiary/serviceDeleteTravelDiary.php'),
      body: json.encode(mytraveldiary.toJson()),
      headers: {"Content-Type": "application/json"}
  );

  //เอาทผลี่ส่งกลับมาส่งกลับไปยังจุดเรียกใช้เพื่อนำข้อมูลที่ส่งกลับมาไปใช้งาน
  if(response.statusCode == 201){
    final resData = json.decode(response.body);
    return resData['message'];
  }
  else{
    return null;
  }
}