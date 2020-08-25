import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/login_blog.dart';
import 'package:form_validation/src/bloc/register_bloc.dart';
export 'package:form_validation/src/bloc/login_blog.dart';

class Provider extends InheritedWidget{
  final loginBlog = LoginBloc();
  final registerBloc = RegistroBloc();

  static Provider _instancia;

  factory Provider({Key key, Widget child}){
    if(_instancia == null){
      _instancia = new Provider._internal(key:key, child: child,);
    }

    return _instancia;
  }

   Provider._internal({Key key, Widget child})
  : super(key: key, child: child);


  // Provider({Key key, Widget child})
  // : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context) {
    return ( context.dependOnInheritedWidgetOfExactType<Provider>()).loginBlog;
  }
  static RegistroBloc registroBloc (BuildContext context) {
    return ( context.dependOnInheritedWidgetOfExactType<Provider>()).registerBloc;
  }

}