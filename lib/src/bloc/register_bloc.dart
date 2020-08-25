
import 'package:form_validation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class RegistroBloc with Validators{

  final _nombreController = new BehaviorSubject<String>();
  final _apellidoController = new BehaviorSubject<String>();
  final _emailController = new BehaviorSubject<String>();
  final _passwordController = new BehaviorSubject<String>();

  Stream<String> get nombreStream => _nombreController.stream.transform(validarString);
  Stream<String> get apellidosStream => _apellidoController.stream.transform(validarString);
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream => Rx.combineLatest4(emailStream, passwordStream, nombreStream, apellidosStream, (e, p, n, a) => true);

  //Insertar valores al stream
  Function(String) get changeNombre => _nombreController.sink.add;
  Function(String) get changeApellido => _apellidoController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Obtener ultimo valor ingresado en los streams
  String get nombre => _nombreController.value;
  String get apellidos => _apellidoController.value;
  String get email => _emailController.value;
  String get password => _passwordController.value;


  _dispose(){
    _nombreController?.close();
    _apellidoController?.close();
    _emailController?.close();
    _passwordController?.close();
  }

}