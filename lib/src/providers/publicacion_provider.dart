import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:form_validation/src/models/postType_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:form_validation/enums/enum_apis.dart';
import 'package:form_validation/src/models/post_model.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:form_validation/src/providers/father_class.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;

import 'api_provider.dart';

class PostProvider extends FatherClass{

  final _prefs = new PreferenciasUsuario();
  final apiProvider = new ApiProvider();

  int _postPage = 0;
  bool _cargando = false;


  List<Post> _posts = new List();
  final _postStreamController = StreamController<List<Post>>.broadcast();

  Function(List<Post>) get postSink => _postStreamController.sink.add;

  Stream<List<Post>> get postStream => _postStreamController.stream;

  void disposeStreams(){
    _postStreamController?.close();
  }

  Future<List<Post>> getPost([bool reload = false]) async {
    if(reload == true){
      _postPage = 0;
      _cargando = false;
      postSink(null);
    }
    if(_cargando) return [];
    _cargando = true;
    _postPage++;

    Map<String, dynamic> res = await apiProvider.get_api([_postPage.toString()], ApisEnum.getPosts);
    print(res);
    if(res.containsKey('pages')){
      if(_postPage < res['pages']){
        _cargando = false;
      }
      final arrayQuestions = _processPostData(res);
      _posts.addAll(arrayQuestions);
      postSink( _posts );
    }
    return _processPostData(res);
  }

  Future<List<Post>> getFavoriteQuestion([bool reload = false]) async {
    if(reload == true){
      _postPage = 0;
      _cargando = false;
      postSink(null);
    }
    if(_cargando) return [];
    _cargando = true;
    _postPage++;

    Map<String, dynamic> res = await apiProvider.get_api([_postPage.toString()], ApisEnum.getFavoriteQuestions);
    print(res);
    if(res.containsKey('pages')){
      if(_postPage < res['pages']){
        _cargando = false;
      }
      final arrayQuestions = _processPostData(res);
      _posts.addAll(arrayQuestions);
      postSink( _posts );
    }
    return _processPostData(res);
  }

   Future<List<Post>> getMyQuestions([bool reload = false]) async {
    if(reload == true){
      _postPage = 0;
      _cargando = false;
      postSink(null);
    }
    if(_cargando) return [];
    _cargando = true;
    _postPage++;

    Map<String, dynamic> res = await apiProvider.get_api([_postPage.toString()], ApisEnum.getMyQuestions);
    print(res);
    if(res.containsKey('pages')){
      if(_postPage < res['pages']){
        _cargando = false;
      }
      final arrayQuestions = _processPostData(res);
      _posts.addAll(arrayQuestions);
      postSink( _posts );
    }
    return _processPostData(res);
  }
  
  List<Post> _processPostData(Map<String, dynamic> json){
    if(json.containsKey('questions')){
      final posts = new Posts.fromJsonList(json['questions']);
      return posts.items;
    }
    return [];
  }

  Future<String> uploadImage(File image) async{
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': _prefs.token
    };

    final url = Uri.parse(ApisEnum.url + '/api/publicacion/uploadImage');
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
      print(response.id);
    }else{
      return 'Error';
    }
    return response.id;
  }

  Future<ResponseModel> newPost(String titulo, String mensaje, bool isQuestion, [PostType tipoPublicacion]) async{
    final auth_data = {
      'titulo': titulo,
      'mensaje': mensaje,
      'isQuestion': isQuestion,
      'tipoPublicacion': tipoPublicacion != null ? tipoPublicacion.id : ''
    };
    print(auth_data);
    Map<String,dynamic> res = await apiProvider.post_api(auth_data,ApisEnum.newPost);
    print(res);
    return this.reponseModelPostApi(res);
  }

  Future<bool> likePost(dynamic id) async {
    final auth_data = {
      'id': id
    };
    Map<String,dynamic> res = await apiProvider.post_api(auth_data,ApisEnum.likePost);
    final like = this.reponseModelPostApi(res);
    print(res);
    return like.id;
  }



  //Publicaciones como admin

  Future<List<Post>> getPostAdmin([bool reload = false]) async{
    if(reload == true){
      _postPage = 0;
      _cargando = false;
      postSink(null);
    }
    if(_cargando) return [];
    _cargando = true;
    _postPage++;

    Map<String, dynamic> res = await apiProvider.get_api([_postPage.toString()], ApisEnum.getPostAdmin);
    print(res);
    if(res.containsKey('pages')){
      if(_postPage < res['pages']){
        _cargando = false;
      }
      final arrayQuestions = _processPostData(res);
      _posts.addAll(arrayQuestions);
      postSink( _posts );
    }
    return _processPostData(res);
  }

  Future<ResponseModel> editPost(String id ,String titulo, String mensaje, bool isQuestion, [PostType tipoPublicacion] ) async {
    final auth_data = {
      'id': id,
      'titulo': titulo,
      'mensaje': mensaje,
      'isQuestion': isQuestion,
      'tipoPublicacion': tipoPublicacion != null ? tipoPublicacion.id : ''
    };
    print(auth_data);
    Map<String,dynamic> res = await apiProvider.post_api(auth_data,ApisEnum.editPostAdmin);
    print(res);
    return this.reponseModelPostApi(res);
  }


}