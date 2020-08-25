class ResponseModel{
  bool success;
  String message;

  ResponseModel({this.success,this.message});

  ResponseModel.fromJsonMap(Map<String,dynamic> json) {
    this.success = json['success'];
    this.message = json['message'];
  }
}