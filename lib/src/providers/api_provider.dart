import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:form_validation/enums/enum_apis.dart';

class ApiProvider{

  String _url = 'https://dry-anchorage-61118.herokuapp.com';

  Map<String, String> _headers = {
      'Content-Type': 'application/json; charset=UTF-8'
  };

  Future<dynamic> post_api(dynamic body, String api) async{
    
    http.Response resp = await http.post(_url + api,headers: _headers, body: jsonEncode(body));
    if(resp.statusCode == 200){
      final res = json.decode(resp.body);
      return res;
    }else{
      return {
        'message': 'Error de conexión',
        'success': 'false'
      };
    }
  }

  Future<Map<String,dynamic>> get_api(List<String> params, String api) async {
    if(params.length > 0){
      //Se hace la llamada sin parametros
      api = _urlParams(params, api);
    }
    //Aqui se hace la llamada
    
  }



  String _urlParams(List<String> params, String api){
    List<String> urlDivided;
    if(params.length<=0){
      return api;
    }else{
      urlDivided = api.split('?');
      int j=0;
      List<String> url = [];
      for (var i = 0; i < urlDivided.length; i++) {
        if(urlDivided[i] != ''){
          url.add(urlDivided[i]);
        }else{
          break;
        }
        if(params.length-1>=i){
          url.add(params[j]);
          j++;
        }
      }
      return url.join();  
    }
  }

  

}