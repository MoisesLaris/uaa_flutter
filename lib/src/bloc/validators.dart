
import 'dart:async';

class Validators {

  final validarEmail = StreamTransformer<String,String>.fromHandlers(
    handleData: (email, sink) {
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);
      if(regExp.hasMatch(email)){
        sink.add(email);
      }else{
        sink.addError('Email no valido');
      }
    },
  );

  final validarPassword = StreamTransformer<String,String>.fromHandlers(
    handleData: (password, sink) {
      
      if(password.length >= 6){
        sink.add(password);
      }else{
        sink.addError('Se requieren mas de 6 caracteres');
      }
    },
  );

  final validarString = StreamTransformer<String,String>.fromHandlers(
    handleData: (password, sink) {

      if(password.length > 0){
        sink.add(password);
      }else{
        sink.addError('El campo no puede estar vacío');
      }
    },
  );
}