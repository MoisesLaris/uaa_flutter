import 'package:flutter/material.dart';
import 'package:form_validation/theme/theme.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/pages/faq/questions/questions_control_page.dart';
import 'package:form_validation/src/pages/home_page.dart';
import 'package:form_validation/src/pages/auth_pages/login_page.dart';
import 'package:form_validation/src/pages/menu/admin_pages/post/post_control_page.dart';
import 'package:form_validation/src/pages/menu/admin_pages/postType/postType_control_page.dart';
import 'package:form_validation/src/pages/menu/admin_pages/users/user_page.dart';
import 'package:form_validation/src/pages/auth_pages/registro_page.dart';
import 'package:form_validation/src/pages/menu/user_pages/faq/new_faq.dart';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:provider/provider.dart' as providerDart;

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
    
    return providerDart.ChangeNotifierProvider(
      create: (_) => ThemeChanger(_prefs.darkMode),  // Aqui ponemos las preferencias de usuario para que guarde el tema
      child: MaterialAppWithTheme(),
    );
  }
}


class MaterialAppWithTheme extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    final currentTheme = providerDart.Provider.of<ThemeChanger>(context).currentTheme;
    final _prefs = PreferenciasUsuario();
    print(_prefs.token);
    return MaterialApp(
          theme: currentTheme,
          debugShowCheckedModeBanner: false,
          title: 'uaa_app',
          initialRoute: 'login',
          routes: {
            'login': (BuildContext context) => LoginPage(),
            'home': (BuildContext context) => HomePage(),
            'registro': (BuildContext context) => RegisterPage(),
            //Admin pages
            'users': (BuildContext context) => UserPage(),
            'postType': (BuildContext context) => PostTypeControl(),
            'post': (BuildContext context) => PostControlPage(ModalRoute.of(context).settings.arguments),
            //User pages
            'newFaq': (BuildContext context) => NewFAQ(),
            //Quiestion pages
            'questions': (BuildContext context) => QuestionControlPage(ModalRoute.of(context).settings.arguments)
          },
    );
  }
}