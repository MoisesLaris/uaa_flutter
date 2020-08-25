import 'dart:convert';
import 'package:form_validation/enums/enum_apis.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:form_validation/src/providers/api_provider.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final apiProvider = new ApiProvider();
  final _prefs = new PreferenciasUsuario();
  //https://dry-anchorage-61118.herokuapp.com

  Future<ResponseModel> nuevoUsuario(String nombre, String apellidos, String email, String password) async {
    final auth_data = {
      'nombre': nombre,
      'apellidos': apellidos,
      'email': email,
      'password': password
    };
    
    print(auth_data);

    Map<String,dynamic> res = await apiProvider.post_api(auth_data,ApisEnum.new_user);
    print('resp:$res');
    if (res.containsKey('success') || res.containsKey('message')) {
      if (res['success']) {
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

  Future<ResponseModel> login(String email, String password) async {
    final auth_data = {
      'email': email,
      'password': password
    };
    
    print(auth_data);

    Map<String,dynamic> res = await apiProvider.post_api(auth_data, ApisEnum.login);


    if (res.containsKey('token')) {
      //AQUI GUARDAMOS EL TOKEN JWT
      _prefs.token = res['token'];
      return ResponseModel.fromJsonMap({'success':true, 'message': 'Bienvenido'});
    }else{
      print(res);
      return ResponseModel.fromJsonMap({'success':false, 'message': res['message']});
    }
    
  }
}
