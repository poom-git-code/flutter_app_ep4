import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_ep4/utils/service_api.dart';
import 'package:image_picker/image_picker.dart';

class InsertMyTravel extends StatefulWidget {
  @override
  _InsertMyTravelState createState() => _InsertMyTravelState();
}

class _InsertMyTravelState extends State<InsertMyTravel> {

  //สร้างตัว controller ผูกกับ TextField
  TextEditingController tStateCtrl = TextEditingController();
  TextEditingController tNumCtrl = TextEditingController();
  TextEditingController tDayCtrl = TextEditingController();
  TextEditingController tPayCtrl = TextEditingController();

  File _selectImage;
  String _selectImageBase64 = '';
  String _selectImageName = '';

  _selectImageFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );
    //ถ้า pickedFile ไม่มีรูปให้มัน return ออกไปเลย
    if(pickedFile == null) return;
    setState(() {
      //จะเอารุปจาก pickedFile มากำหนดให้กับ _selectImage
      _selectImage = File(pickedFile.path);
      //เเปลงรูปเป็น Base64 เก็บในตัวแปร _selectImageBase64
      _selectImageBase64 = base64Encode(_selectImage.readAsBytesSync());
      //ชื่อรูปเก็บในตัวแปร _selectImageName
      _selectImageName = _selectImage.path.split('/').last;
    });
  }

  _selectImageFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    //ถ้า pickedFile ไม่มีรูปให้มัน return ออกไปเลย
    if(pickedFile == null) return;
    setState(() {
      //จะเอารุปจาก pickedFile มากำหนดให้กับ _selectImage
      _selectImage = File(pickedFile.path);
      //เเปลงรูปเป็น Base64 เก็บในตัวแปร _selectImageBase64
      _selectImageBase64 = base64Encode(_selectImage.readAsBytesSync());
      //ชื่อรูปเก็บในตัวแปร _selectImageName
      _selectImageName = _selectImage.path.split('/').last;
    });
  }

  _showSelectFromCamGal(context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context){
        return Row(
          children: [
            Expanded(
              child: FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  _selectImageFromCamera();
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.green[400],
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  _selectImageFromGallery();
                },
                child: Icon(
                  Icons.camera,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showWarningDialog(String msg) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Center(
                child: Container(
                  width: double.infinity,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'คำเตือน !!!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/mylogo.png',
                  width: 80,
                ),
                SizedBox(height: 15,),
                Text(
                  msg,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 10,),
                RaisedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  color: Colors.orange[300],
                  child: Text(
                    'ตกลง',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xffF7C289),
          );
        }
    );
  }

  _showConfirmDialog(String msg) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Center(
                child: Container(
                  width: double.infinity,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'คำเตือน !!!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        //ต้องส่งข้อมูลที่จะบันทึกไปที่ Service insert ไปที่ Server
                        //ผ่านทาง api ไปที่เราจะสร้าง
                        Navigator.pop(context);
                        String message = await serviceInsertTravelDiary(
                            tStateCtrl.text,
                            _selectImageBase64,
                            tNumCtrl.text,
                            tDayCtrl.text,
                            tPayCtrl.text,
                            _selectImageName
                        );
                        if(message == '1'){
                          //ถ้าเท่ากับ 1 ให้กลับไปหน้าเเรก
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }
                        else{
                          //แสดง dialog แจ้งบันทึกไม่สำเร็จ
                          _showInsertResultDialog('บันทึกไม่สำเร็จ');
                        }
                      },
                      color: Colors.orange[300],
                      child: Text(
                        'บันทึก',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green[600]
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    RaisedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      color: Colors.orange[300],
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red[600]
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: Color(0xffF7C289),
          );
        }
    );
  }

  _showInsertResultDialog(String msg) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Center(
                child: Container(
                  width: double.infinity,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'ผลการบันทึก',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15,),
                Text(
                  msg,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                SizedBox(height: 10,),
                RaisedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  color: Colors.orange[300],
                  child: Text(
                    'ตกลง',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xffF7C289),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Travel Diary 2010 (เพิ่ม)',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
          ),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 28.0,),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 170,
                      width: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          width: 2,
                          color: Colors.purpleAccent
                        )
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _selectImage == null ? AssetImage('assets/images/mylogo.png') : FileImage(_selectImage)
                          )
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: IconButton(
                          onPressed: (){
                            _showSelectFromCamGal(context);
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, bottom: 10),
                  child: TextField(
                    controller: tStateCtrl,
                    decoration: InputDecoration(
                      labelText: 'สถานที่',
                      labelStyle: TextStyle(
                          color: Colors.orange[400],
                          fontSize: 25
                      ),
                      hintText: 'ชื่อสถานที่ท่องเที่ยว',
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(
                        Icons.account_balance,
                        color: Colors.orange[400],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, bottom: 10),
                  child: TextField(
                    controller: tNumCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]+'))
                    ],
                    decoration: InputDecoration(
                      labelText: 'จำนวน',
                      labelStyle: TextStyle(
                          color: Colors.orange[400],
                          fontSize: 25
                      ),
                      hintText: '0',
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.orange[400],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, bottom: 10),
                  child: TextField(
                    controller: tDayCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]+'))
                    ],
                    decoration: InputDecoration(
                      labelText: 'วัน',
                      labelStyle: TextStyle(
                          color: Colors.orange[400],
                          fontSize: 25
                      ),
                      hintText: '0',
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.orange[400],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, bottom: 10),
                  child: TextField(
                    controller: tPayCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      )
                    ],
                    decoration: InputDecoration(
                      labelText: 'ราคา',
                      labelStyle: TextStyle(
                          color: Colors.orange[400],
                          fontSize: 25
                      ),
                      hintText: '0.00',
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(
                        Icons.monetization_on,
                        color: Colors.orange[400],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, bottom: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          onPressed: (){
                            if(tStateCtrl.text.trim().length == 0){
                              _showWarningDialog('ป้อนชื่อสถานที่ด้วย !!!');
                            }
                            else if(tNumCtrl.text.trim().length == 0){
                              _showWarningDialog('ป้อนจำนวนดนด้วย !!!');
                            }
                            else if(tDayCtrl.text.trim().length == 0){
                              _showWarningDialog('ป้อนจำนวณวันด้วย !!!');
                            }
                            else if(tPayCtrl.text.trim().length == 0){
                              _showWarningDialog('ป้อนราคาด้วย !!!');
                            }
                            else if(_selectImageName.length == 0){
                              _showWarningDialog('กรุณาเลือกรูปด้วย !!!');
                            }
                            else{
                              //สีงข้อมูลไปให้ Service insert เพื่อบันทึกลงฐานข้อมูล
                              _showConfirmDialog('ต้องการบันทึกข้อมูลหรือไม่ !!!');
                            }
                          },
                          child: Text(
                            'บันทึก',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          color: Colors.green[500],
                        ),
                      ),
                      SizedBox(width: 28,),
                      Expanded(
                        child: RaisedButton(
                          onPressed: (){},
                          child: Text(
                            'ยกเลิก',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18
                            ),
                          ),
                          color: Colors.red[500],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
