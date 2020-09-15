import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:form_validation/enums/enum_apis.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/models/user_model.dart';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:form_validation/src/providers/api_provider.dart';
import 'package:form_validation/src/providers/father_class.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class UsuarioProvider extends FatherClass{
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

  Future<ResponseModel> nuevoUsuarioAdmin(String nombre, String apellidos, String email, String password, bool isAdmin) async {
    final auth_data = {
      'nombre': nombre,
      'apellidos': apellidos,
      'email': email,
      'password': password,
      'isAdmin': isAdmin
    };
    
    print(auth_data);

    Map<String,dynamic> res = await apiProvider.post_api(auth_data,ApisEnum.new_user_admin);
    print('resp:$res');
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

  Future<ResponseModel> editarUsuario(String id, String nombre, String apellidos, bool isAdmin) async {
    final auth_data = {
      '_id': id,
      'nombre': nombre,
      'apellidos': apellidos,
      'isAdmin': isAdmin
    };

    Map<String,dynamic> res = await apiProvider.post_api(auth_data, ApisEnum.editUser);

    
  }

  Future<ResponseModel> login(String email, String password) async {
    final auth_data = {
      'email': email,
      'password': password
    };
    
    print(auth_data);

    Map<String,dynamic> res = await apiProvider.post_api(auth_data, ApisEnum.login);


    if (res.containsKey('token') && res.containsKey('user')){
      print(res['user']);
      //AQUI GUARDAMOS EL TOKEN JWT
      this._prefs.token = res['token'];
      this._prefs.image = res['user']['image'];
      this._prefs.nombre = res['user']['nombre'];
      this._prefs.apellidos = res['user']['apellidos'];
      this._prefs.idUser = res['user']['_id'];
      this._prefs.email = res['user']['email'];
      this._prefs.isAdmin = res['user']['isAdmin'];
      return ResponseModel.fromJsonMap({'success':true, 'message': 'Bienvenido'});
    }else{
      print(res);
      return ResponseModel.fromJsonMap({'success':false, 'message': res['message']});
    }
    
  }

  Future<ResponseModel> uploadImage(File image) async{
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': _prefs.token
    };

    final url = Uri.parse(ApisEnum.url + '/api/usuario/uploadImage/${_prefs.idUser}');
    final mimeType = mime(image.path);
    print(url);
    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('image', image.path, contentType: MediaType(mimeType[0],mimeType[1]));
    imageUploadRequest.headers.addAll(headers);
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final respuesta = await http.Response.fromStream(streamResponse);
    ResponseModel response;
    print(respuesta.statusCode);
    Map<String, dynamic> res = json.decode(respuesta.body);
    if(respuesta.statusCode == 200){
      response = new ResponseModel.fromJsonMap(res);
      if(response.success){
        if(res.containsKey('token'))
          this._prefs.token = res['token'];
        if(res.containsKey('user')){
          this._prefs.image = res['user']['image'];
        }
      }
    }else{
      return ResponseModel(message: 'Error de conexión', success: false);
    }
    return response;
  }

  Future<bool> verifyJWT() async{
    final auth_data = {
      'token': this._prefs.token
    };

    Map<String,dynamic> res = await apiProvider.post_api(auth_data, ApisEnum.verifySession);
    print(res);
    if(res.containsKey('nombre') && res.containsKey('apellidos') && res.containsKey('image') && res.containsKey('sub') && res.containsKey('email')){
      this._prefs.image = res['image'];
      this._prefs.nombre = res['nombre'];
      this._prefs.apellidos = res['apellidos'];
      this._prefs.idUser = res['sub'];
      this._prefs.email = res['email'];
      return true;
    }else{
      return false;
    }

  }

  Future<List<User>> getUsers() async{
    final res = await apiProvider.get_api([], ApisEnum.getUsers);
    print(res['usuarios']);
    final usuarios = new Users.fromJsonList(res['usuarios']);
    return usuarios.items;
  }

  Future<ResponseModel> editUser(User user) async{
    final body = {
      'id': user.id,
      'nombre': user.nombre,
      'apellidos': user.apellidos,
      'isAdmin': user.isAdmin
    };
    print(body);
    final res = await apiProvider.post_api(body, ApisEnum.editUser);
    return this.reponseModelPostApi(res);
  }

  void logout(BuildContext context) async{
    this._prefs.token = '';
    this._prefs.email = '';
    this._prefs.nombre = '';
    this._prefs.image = '';
    this._prefs.apellidos = '';
    this._prefs.idUser = '';
    this._prefs.isAdmin = false;
    Navigator.pushReplacementNamed(context, 'login');
  }
  
}
