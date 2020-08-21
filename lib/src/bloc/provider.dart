import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/login_blog.dart';
export 'package:form_validation/src/bloc/login_blog.dart';

class Provider extends InheritedWidget{

  static Provider _instancia;

  factory Provider({Key key, Widget child}){
    if(_instancia == null){
      _instancia = new Provider._internal(key:key, child: child,);
    }

    return _instancia;
  }

   Provider._internal({Key key, Widget child})
  : super(key: key, child: child);

  final loginBlog = LoginBloc();

  // Provider({Key key, Widget child})
  // : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context) {
    return ( context.dependOnInheritedWidgetOfExactType<Provider>()).loginBlog;
  }

}