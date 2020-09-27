import 'package:form_validation/src/models/response_model.dart';

class FatherClass{



  ResponseModel reponseModelPostApi(Map<String,dynamic> res){
    if (res.containsKey('success') || res.containsKey('message') || res.containsKey('id')) {
        return ResponseModel.fromJsonMap(res);
    }else{
      return ResponseModel.fromJsonMap({'success':false, 'message': 'Error en la conexión'});
    }
  }


}