import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/pages/home_page.dart';
import 'package:form_validation/src/pages/auth_pages/login_page.dart';
import 'package:form_validation/src/pages/menu/admin_pages/postType/postType_control_page.dart';
import 'package:form_validation/src/pages/menu/admin_pages/users/user_page.dart';
import 'package:form_validation/src/pages/auth_pages/registro_page.dart';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _prefs = PreferenciasUsuario();
    print(_prefs.token);
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'uaa_app',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'registro': (BuildContext context) => RegisterPage(),
          //Admin pages
          'users': (BuildContext context) => UserPage(),
          'postType': (BuildContext context) => PostTypeControl()
        },
      ),
    );
  }
}
