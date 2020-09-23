import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/pages/configuracion/configuration_page.dart';
import 'package:form_validation/src/pages/faq/faq_page.dart';
import 'package:form_validation/src/pages/menu/menu_page.dart';
import 'package:form_validation/src/pages/menu/user_pages/faq/new_faq.dart';
import 'package:form_validation/src/providers/usuario_provider.dart';
import 'package:form_validation/src/widgets/flushbar_feedback.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void initState() {
    super.initState();

  }
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: () {
            UsuarioProvider().logout(context);
          })
        ],
        title: Text('Inicio'),
      ),
      body: _callPage(_currentIndex), 
      bottomNavigationBar:  Builder(builder: (context) => _crearBottomNavigationBar(context)),
    );

  }

  Widget _crearBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index){
        setState(() {
          _currentIndex = index;
          //FlushbarFeedback.flushbar_feedback(context,'hola','mundo',Icons.check_circle,true);
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home),title: Text('Inicio')),
        BottomNavigationBarItem(icon: Icon(Icons.question_answer),title: Text('Faq')),
        BottomNavigationBarItem(icon: Icon(Icons.settings),title: Text('Configuración')),
      ],
    );
  }

  Widget _callPage(int paginaActual) {
    print(_currentIndex);
    switch(paginaActual){
      case 0: return MenuPage();
      case 1: return FaqPage();
      case 2: return ConfigurationPage();
      default:
        return MenuPage();
    }
  }
}