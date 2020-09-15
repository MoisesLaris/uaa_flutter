

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
  // bool _email;
  // int _apellidos;
  // String _nombre;

  //GET y SET del apellidos

  get token{
    return _prefs.getString('token') ?? ' ';
  }

  set token(String token){
    this._prefs.setString('token', token);
  }

  get apellidos{
    return _prefs.getString('apellidos') ?? '';
  }

  set apellidos(String value){
    this._prefs.setString('apellidos', value);
  }
  
  get email{
    return _prefs.getString('email') ?? '';
  }

  set email(String value){
    this._prefs.setString('email', value);
  }

  get nombre{
    return _prefs.getString('nombre') ?? '';
  }

  set nombre(String value){
    this._prefs.setString('nombre', value);
  }

  get isAdmin{
    return _prefs.getBool('isAdmin') ?? false;
  }

  set isAdmin(bool value){
    this._prefs.setBool('isAdmin', value);
  }

  get image{
    return _prefs.getString('image') ?? '';
  }

  set image(String value){
    this._prefs.setString('image', value);
  }

  get idUser{
    return _prefs.getString('idUser');
  }

  set idUser(String value){
    this._prefs.setString('idUser', value);
  }

}