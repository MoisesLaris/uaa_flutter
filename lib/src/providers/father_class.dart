import 'package:form_validation/src/models/response_model.dart';

class FatherClass{



  ResponseModel reponseModelPostApi(Map<String,dynamic> res){
    if (res.containsKey('success') || res.containsKey('message')) {
      if (res['success'] == true) {
        print(res['message']);
        return ResponseModel.fromJsonMap({'success':true, 'message': res['message']});
      } else {
        print(res['message']);
        return ResponseModel.fromJsonMap({'success':false, 'message': res['message']});
      }
    }else{
      return ResponseModel.fromJsonMap({'success':false, 'message': 'Error en la conexión'});
    }
  }


}