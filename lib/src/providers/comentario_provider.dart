

import 'dart:async';
import 'package:form_validation/enums/enum_apis.dart';
import 'package:form_validation/src/models/comment_model.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/providers/father_class.dart';
import 'api_provider.dart';

class CommentProvider extends FatherClass{
  final apiProvider = new ApiProvider();

  int _commentPage = 0;
  bool _cargando = false;

  List<Comment> _comments = new List();
  final _commentStreamController = StreamController<List<Comment>>.broadcast();

  Function(List<Comment>) get commentSink => _commentStreamController.sink.add;

  Stream<List<Comment>> get commentStream => _commentStreamController.stream;

  void disposeStreams(){
    _commentStreamController?.close();
  }

  Future<List<Comment>> getComment(String idPost,[bool reload = false]) async {
    if(reload == true){
      _comments.clear();
      _commentPage = 0;
      _cargando = false;
      commentSink(null);
    }
    if(_cargando) return [];
    _cargando = true;
    _commentPage++;

    Map<String, dynamic> res = await apiProvider.get_api([idPost, _commentPage.toString()], ApisEnum.getComment);
    print(res);
    if(res.containsKey('pages')){
      if(_commentPage < res['pages']){
        _cargando = false;
      }
      final arrayComments = _processPostData(res);
      print(arrayComments);
      _comments.addAll(arrayComments);
      commentSink( _comments );
    }
    return _processPostData(res);
  }

  List<Comment> _processPostData(Map<String, dynamic> json){
    if(json.containsKey('comments')){
      final posts = new Comments.fromJsonList(json['comments']);
      return posts.items;
    }
    return [];
  }

  Future<ResponseModel> newComment({idPublicacion, comentario}) async{
    final auth_data = {
      'idPublicacion': idPublicacion,
      'comentario': comentario,
    };
    print(auth_data);
    Map<String,dynamic> res = await apiProvider.post_api(auth_data,ApisEnum.newComment);
    print(res);
    return this.reponseModelPostApi(res);
  }

  void addComment(Comment comment){
    _comments.insert(0, comment);  
    commentSink(_comments);  
  }

  
}