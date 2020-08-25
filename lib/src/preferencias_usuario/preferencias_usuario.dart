

import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario{

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario(){
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async{
    this._prefs = await SharedPreferences.getInstance();
  }

  //Ninguna de estas propiedades se usa
  // bool _colorSecundario;
  // int _genero;
  // String _nombre;

  //GET y SET del genero

  get token{
    return _prefs.getString('token') ?? '';
  }

  set token(String token){
    this._prefs.setString('token', token);
  }

  get genero{
    return _prefs.getInt('genero') ?? 1;
  }

  set genero(int value){
    this._prefs.setInt('genero', value);
  }
  
  get colorSecundario{
    return _prefs.getBool('color') ?? false;
  }

  set colorSecundario(bool value){
    this._prefs.setBool('color', value);
  }

  get nombre{
    return _prefs.getString('nombre') ?? 'Ninguno';
  }

  set nombre(String value){
    this._prefs.setString('nombre', value);
  }


  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'home';
  }

  set ultimaPagina(String value){
    this._prefs.setString('ultimaPagina', value);
  }


}