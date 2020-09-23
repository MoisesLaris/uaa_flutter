
import 'package:flutter/material.dart';
import 'package:form_validation/src/models/app_models/menuitem_model.dart';

List<MenuItem_Model> faqItems = [
  MenuItem_Model( icon: Icons.question_answer, title: 'Preguntas',color: Colors.lightBlue, route: 'questions', isAdmin: false),
  MenuItem_Model( icon: Icons.add_comment, title: 'Nueva pregunta',color: Colors.blueAccent, route: 'newFaq', isAdmin: false),
  MenuItem_Model( icon: Icons.person, title: 'Mis preguntas',color: Colors.orange, route: 'postType', isAdmin: true),
  MenuItem_Model( icon: Icons.star, title: 'Favoritas',color: Colors.yellow[600], route: 'postType', isAdmin: true),
  // MenuItem_Model( icon: Icons.feedback, title: 'Preguntas',color: Colors.lightGreen, route: 'hom', isAdmin: true),
  // MenuItem_Model( icon: Icons.star, title: 'Favoritos',color: Colors.yellow[600], route: 'hom', isAdmin: true),
  
];