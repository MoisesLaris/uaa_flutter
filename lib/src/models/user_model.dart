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
    json.containsKey('_id') ? this.id = json['_id'] : this.id = '';
    json.containsKey('nombre') ? this.nombre = json['nombre'] : this.nombre = '';
    json.containsKey('apellidos') ? this.apellidos = json['apellidos'] : this.apellidos = '';
    json.containsKey('email') ? this.email = json['email'] : this.email = '';
    json.containsKey('password') ? this.password = json['password'] : this.password = '';
    json.containsKey('isAdmin') ? this.isAdmin = json['isAdmin'] : this.isAdmin = false;
    json.containsKey('image') ? json['image'] != null ? this.image = json['image'] : this.image = 'none' : this.image = 'none';
  }

}