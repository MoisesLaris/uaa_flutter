class ResponseModel{
  bool success;
  String message;
  dynamic id;

  ResponseModel({this.success,this.message});

  ResponseModel.fromJsonMap(Map<String,dynamic> json) {
    this.success = json['success'];
    this.message = json['message'];
    this.id = json['id'];
  }
}