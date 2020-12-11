import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/pages/configuracion/configuration_page.dart';
import 'package:form_validation/src/pages/faq/faq_page.dart';
import 'package:form_validation/src/pages/menu/admin_pages/post/post_control_page.dart';
import 'package:form_validation/src/pages/menu/menu_page.dart';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:form_validation/src/providers/usuario_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController _pageController;
  final _prefs = PreferenciasUsuario();

  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() { 
    _pageController.dispose();
    super.dispose();
  }


  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

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
          _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
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
    return PageView(
      physics: BouncingScrollPhysics(),
      controller: _pageController,
      onPageChanged: (index){
        setState(() {
          _currentIndex = index;
        });
      },
      children: <Widget>[
        _prefs.isAdmin ? MenuPage() : PostControlPage(false),
        FaqPage(),
        ConfigurationPage()
      ],
    );
    // switch(paginaActual){
    //   case 0: return MenuPage();
    //   case 1: return FaqPage();
    //   case 2: return ConfigurationPage();
    //   default:
    //     return MenuPage();
    // }
  }
}