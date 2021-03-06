import 'package:form_validation/src/models/postType_model.dart';
import 'package:form_validation/src/models/user_model.dart';

class Posts{
  List<Post> items = new List();

  Posts();

  Posts.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null) return;
    for(var item in jsonList){
      final post = new Post.fromJsonMap(item);
      items.add( post );
    }
  }
}


class Post {
  String id;
  String titulo;
  String mensaje;
  User idUser;
  PostType tipoPublicacion;
  List<dynamic> users;
  String comentarios;
  bool isQuestion;
  DateTime fecha;
  String image;
  

  Post({
    this.id,
    this.titulo,
    this.mensaje,
    this.idUser,
    this.tipoPublicacion,
    this.users,
    this.comentarios,
    this.isQuestion,
    this.fecha,
    this.image 
  });

  Post.empty(){
    this.id = '';
    this.titulo = '';
    this.mensaje = '';
    this.idUser = new User.empty();
    this.tipoPublicacion = PostType.empty();
    this.users = [];
    this.comentarios = '';
    this.isQuestion = false;
    this.fecha = new DateTime.now();
    this.image = '';
  }

  Post.fromJsonMap(Map<String,dynamic> json){
    json.containsKey('_id') ? this.id = json['_id'] : this.id = ''; 
    json.containsKey('titulo') ? this.titulo = json['titulo'] : this.titulo = ''; 
    json.containsKey('mensaje') ? this.mensaje = json['mensaje'] : this.mensaje = ''; 
    json.containsKey('idUser') ? this.idUser = User.fromJsonMap(json['idUser']) : this.idUser = new User.empty(); 
    json.containsKey('tipoPublicacion') ?  json['tipoPublicacion'] != null ? this.tipoPublicacion = PostType.fromJsonMap(json['tipoPublicacion']) : this.tipoPublicacion = PostType.empty() : this.tipoPublicacion = PostType.empty(); 
    //json.containsKey('comentarios') ? this.comentarios = json['comentarios'] : this.comentarios = ''; 
    json.containsKey('isQuestion') ? this.isQuestion = json['isQuestion'] : this.isQuestion = true; 
    json.containsKey('fecha') ? this.fecha = DateTime.parse(json['fecha']) : this.fecha = new DateTime.now(); 
    json.containsKey('image') ? this.image = json['image'] : this.image = 'none';
    json.containsKey('users') ? this.users = json['users'] : this.users = [];

  }

}