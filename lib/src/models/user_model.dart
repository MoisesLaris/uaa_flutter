
class User {
  String _id;
  String nombre;
  String apellidos;
  String email;
  String password;
  

  User({
    String id,
    this.nombre,
    this.apellidos,
    this.email,
    this.password,  
  }):_id = id;

  User.fromJsonMap(Map<String,dynamic> json){
    _id = json['_id'];
    nombre = json['nombre'];
    apellidos = json['apellidos'];
    email = json['email'];
    password = json['password'];
  }
}