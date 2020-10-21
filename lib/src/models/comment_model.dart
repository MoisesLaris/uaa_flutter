
import 'package:form_validation/src/models/user_model.dart';

class Comments{
  List<Comment> items = new List();

  Comments();

  Comments.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null) return;
    for(var item in jsonList){
      final comment = new Comment.fromJsonMap(item);
      items.add( comment );
    }
  }
}

class Comment{
  String id;
  User idUser;
  String idPublicacion;
  String comentario;
  DateTime fecha;

  Comment({
    this.id,
    this.idUser,
    this.idPublicacion,
    this.comentario,
    this.fecha
  });

  Comment.empty(){
    this.id = '';
    this.idUser = new User.empty();
    this.idPublicacion = '';
    this.comentario = '';
    this.fecha = new DateTime.now();
  }

  Comment.fromJsonMap(Map<String, dynamic> json) {
    json.containsKey('_id') ? this.id = json['_id'] : this.id = ''; 
    json.containsKey('idUser') ? this.idUser = User.fromJsonMap(json['idUser']) : this.idUser = User.empty(); 
    json.containsKey('idPublicacion') ? this.idPublicacion = json['idPublicacion'] : this.idPublicacion = ''; 
    json.containsKey('comentario') ? this.comentario = json['comentario'] : this.comentario = '';
    json.containsKey('fecha') ? this.fecha = DateTime.parse(json['fecha']) : this.fecha = new DateTime.now();
  }

}