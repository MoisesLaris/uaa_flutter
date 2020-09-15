class PostTypes{
  List<PostType> items = new List();

  PostTypes();

  PostTypes.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null) return;
    for(var item in jsonList){
      final user = new PostType.fromJsonMap(item);
      items.add( user );
    }
  }
}

class PostType {
  String id;
  String nombre;
  String descripcion;

  PostType({this.id, this.nombre});

  PostType.empty(){
    this.id = '';
    this.nombre = '';
    this.descripcion = '';
  }

   PostType.fromJsonMap(Map<String,dynamic> json){
    json.containsKey('_id') ? id = json['_id'] : id = '';
    json.containsKey('nombre') ? nombre = json['nombre'] : nombre = '';
    json.containsKey('descripcion') ? descripcion = json['descripcion'] : descripcion= '';
  }

}