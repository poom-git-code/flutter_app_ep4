

class Mytraveldiary {
  String message;
  String tId;
  String tState;
  String tImage;
  String tNum;
  String tDay;
  String tPay;
  String tDate;
  String imageName;

  Mytraveldiary(
      {this.message,
        this.tId,
        this.tState,
        this.tImage,
        this.tNum,
        this.tDay,
        this.tPay,
        this.tDate,
        this.imageName
      });

  Mytraveldiary.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    tId = json['tId'];
    tState = json['tState'];
    tImage = json['tImage'];
    tNum = json['tNum'];
    tDay = json['tDay'];
    tPay = json['tPay'];
    tDate = json['tDate'];
    imageName = json['imageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['tId'] = this.tId;
    data['tState'] = this.tState;
    data['tImage'] = this.tImage;
    data['tNum'] = this.tNum;
    data['tDay'] = this.tDay;
    data['tPay'] = this.tPay;
    data['tDate'] = this.tDate;
    data['imageName'] = this.imageName;
    return data;
  }
}