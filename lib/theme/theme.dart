import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier{

  ThemeChanger(bool dark){
    if(dark){
      _darkTheme = true;
      _currentTheme = ThemeData.dark().copyWith(
        accentColor: Colors.pink,
        accentIconTheme: IconThemeData(color: Colors.pink),
        highlightColor: Colors.pink,
        buttonColor: Colors.pink,
        cursorColor: Colors.pink,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.pink,
        ),
        toggleableActiveColor: Colors.pink
        
      );
    }else{
      _darkTheme = false;
      _currentTheme = ThemeData.light();
    }
  }


  bool _darkTheme = false;
  ThemeData _currentTheme;


  bool get darkTheme => this._darkTheme;
  
  set darkTheme( bool value ){
    _darkTheme = value;
    print(value);
    if(value){
      _currentTheme = ThemeData.dark().copyWith(
        accentColor: Colors.pink,
        accentIconTheme: IconThemeData(color: Colors.pink),
        highlightColor: Colors.pink,
        buttonColor: Colors.pink,
        cursorColor: Colors.pink,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.pink,
        ),
        toggleableActiveColor: Colors.pink,
      );
    }else{
      _currentTheme = ThemeData.light();
    }
    
    notifyListeners();
  } 

  ThemeData get currentTheme => _currentTheme;

}