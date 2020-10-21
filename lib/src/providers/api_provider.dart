import 'dart:convert';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:form_validation/enums/enum_apis.dart';

class ApiProvider{
  final _prefs = PreferenciasUsuario();

  Map<String, String> _headers = {
      'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<dynamic> post_api(dynamic body, String api) async{
    _headers['Authorization'] = _prefs.token;
    http.Response resp = await http.post(ApisEnum.url + api,headers: _headers, body: jsonEncode(body));
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


  Future<dynamic> post_with_params_api(dynamic body,List<String> params ,String api) async{
    _headers['Authorization'] = _prefs.token;
    if(params.length > 0){
      api = _urlParams(params, api);
    }
    http.Response resp = await http.post(ApisEnum.url + api, headers: _headers, body: jsonEncode(body));
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
    _headers['Authorization'] = _prefs.token;
    if(params.length > 0){
      //Se hace la llamada sin parametros
      api = _urlParams(params, api);
      print(api);
    }
    //Aqui se hace la llamada
    http.Response resp = await http.get(ApisEnum.url + api, headers: _headers);
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