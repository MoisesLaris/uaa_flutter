
import 'package:flutter/material.dart';
import 'package:form_validation/src/models/app_models/menuitem_model.dart';

List<MenuItem_Model> menuItems = [
  MenuItem_Model( icon: Icons.person, title: 'Usuarios',color: Colors.redAccent, route: 'users', isAdmin: true),
  MenuItem_Model( icon: Icons.add_to_photos, title: 'Tipo publicación',color: Colors.blue, route: 'postType', isAdmin: true),
  MenuItem_Model( icon: Icons.image, title: 'Publicaciones',color: Colors.lightGreen, route: 'post', isAdmin: true, arguments: true),
  MenuItem_Model( icon: Icons.feedback, title: 'Publicaciones',color: Colors.blue[700], route: 'post', isAdmin: false, arguments: false),
  // MenuItem_Model( icon: Icons.star, title: 'Favoritos',color: Colors.yellow[700], route: 'hom', isAdmin: false),
  
];