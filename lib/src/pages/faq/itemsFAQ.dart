
import 'package:flutter/material.dart';
import 'package:form_validation/src/models/app_models/menuitem_model.dart';

List<MenuItem_Model> faqItems = [
  MenuItem_Model( icon: Icons.question_answer, title: 'Preguntas',color: Colors.indigo, route: 'questions', isAdmin: false, arguments: 'all'),
  MenuItem_Model( icon: Icons.person, title: 'Mis preguntas',color: Colors.orange, route: 'questions', isAdmin: true, arguments: 'mine'),
  MenuItem_Model( icon: Icons.star, title: 'Favoritas',color: Colors.yellow[700], route: 'questions', isAdmin: true, arguments: 'favorites'),
  MenuItem_Model( icon: Icons.add_comment, title: 'Nueva pregunta',color: Colors.blueAccent, route: 'newFaq', isAdmin: false),
  
];