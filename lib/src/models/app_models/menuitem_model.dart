import 'package:flutter/material.dart';

@immutable
class MenuItem_Model{
  final IconData icon;
  final String title;
  final Color color;
  final String route;
  final bool isAdmin;
  const MenuItem_Model({@required this.icon, @required this.title, @required this.color, @required this.route, @required this.isAdmin});
}