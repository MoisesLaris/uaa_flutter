class Users {
  List<User> items = new List();

  Users();

  Users.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null) return;
    for(var item in jsonList){
      final user = new User.fromJsonMap(item);
      items.add( user );
    }
  }
}


class User {
  String id;
  String nombre;
  String apellidos;
  String email;
  String password;
  bool isAdmin;
  String image;
  

  User({
    this.id,
    this.nombre,
    this.apellidos,
    this.email,
    this.password,
    this.isAdmin,
    this.image  
  });

  User.empty(){
    this.id = '';
    this.nombre = '';
    this.apellidos = '';
    this.email = '';
    this.password = '';
    this.isAdmin = false;
    this.image = '';
  }

  User.fromJsonMap(Map<String,dynamic> json){
    id = json['_id'];
    nombre = json['nombre'];
    apellidos = json['apellidos'];
    email = json['email'];
    password = json['password'];
    isAdmin = json['isAdmin'];
    image = json['image'];
  }

}