import 'dart:async';

import 'package:form_validation/enums/enum_apis.dart';
import 'package:form_validation/src/models/post_model.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/providers/father_class.dart';

import 'api_provider.dart';

class PostProvider extends FatherClass{

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
  
  List<Post> _processPostData(Map<String, dynamic> json){
    if(json.containsKey('questions')){
      final posts = new Posts.fromJsonList(json['questions']);
      return posts.items;
    }
    return [];
  }

  Future<ResponseModel> newPost(String titulo, String mensaje, bool isQuestion) async{
    final auth_data = {
      'titulo': titulo,
      'mensaje': mensaje,
      'isQuestion': isQuestion
    };
    print(auth_data);
    Map<String,dynamic> res = await apiProvider.post_api(auth_data,ApisEnum.newPost);
    print(res);
    return this.reponseModelPostApi(res);
  }
}