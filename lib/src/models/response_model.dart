class ResponseModel{
  bool success;
  String message;
  dynamic id;

  ResponseModel({this.success,this.message});

  ResponseModel.fromJsonMap(Map<String,dynamic> json) {
    json.containsKey('success') ? this.success = json['success'] : this.success = false;
    json.containsKey('message') ? this.message = json['message'] : this.message = '';
    json.containsKey('id') ? this.id = json['id'] : this.id = '';
  }
}