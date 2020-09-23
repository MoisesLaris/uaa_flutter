import 'package:form_validation/src/models/user_model.dart';

class Posts{
  List<Post> items = new List();

  Posts();

  Posts.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null) return;
    for(var item in jsonList){
      final user = new Post.fromJsonMap(item);
      items.add( user );
    }
  }
}


class Post {
  String id;
  String titulo;
  String mensaje;
  String idUser;
  String tipoPublicacion;
  List<User> users;
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
    this.idUser = '';
    this.tipoPublicacion = '';
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
    json.containsKey('idUser') ? this.idUser = json['idUser'] : this.idUser = ''; 
    json.containsKey('tipoPublicacion') ? this.tipoPublicacion = json['tipoPublicacion'] : this.tipoPublicacion = ''; 
    //json.containsKey('comentarios') ? this.comentarios = json['comentarios'] : this.comentarios = ''; 
    json.containsKey('isQuestion') ? this.isQuestion = json['isQuestion'] : this.isQuestion = true; 
    json.containsKey('fecha') ? this.fecha = json['fecha'] : this.fecha = new DateTime.now(); 
    json.containsKey('image') ? this.image = json['image'] : this.image = 'none'; 

    this.users = [];
    for(var item in json['users']){
      final user = new User.fromJsonMap(item);
      this.users.add(user);
    }
  }

}