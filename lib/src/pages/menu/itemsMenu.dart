
import 'package:flutter/material.dart';
import 'package:form_validation/src/models/app_models/menuitem_model.dart';

const List<MenuItem_Model> menuItems = [
  MenuItem_Model( icon: Icons.person, title: 'Usuarios',color: Colors.redAccent, route: 'users', isAdmin: true),
  MenuItem_Model( icon: Icons.add_to_photos, title: 'Tipo publicación',color: Colors.indigo, route: 'postType', isAdmin: true),
  MenuItem_Model( icon: Icons.feedback, title: 'Preguntas',color: Colors.orange, route: 'hom', isAdmin: true),
  
];