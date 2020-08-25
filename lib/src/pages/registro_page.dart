import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/bloc/register_bloc.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/providers/usuario_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RegisterPage extends StatelessWidget {

  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.blue[900],
        Colors.blue[800],
      ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(
          top: 90.0,
          left: 60.0,
          child: circulo,
        ),
        Positioned(
          top: 0.0,
          right: 30.0,
          child: circulo,
        ),
        Positioned(
          bottom: -50.0,
          right: -10.0,
          child: circulo,
        ),
        Positioned(
          bottom: 150.0,
          right: 10.0,
          child: circulo,
        ),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              // Icon(
              //   Icons.person_pin_circle,
              //   color: Colors.white,
              //   size: 100.0,
              // ),
              Image(
                image: AssetImage('assets/images/uaa.png'),
                height: 100.0,
              ),
              SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              Text(
                'App',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.registroBloc(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
              child: Container(
            height: 180.0,
          )),
          Container(
            width: size.width * .85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 3.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                Text(
                  'Crear cuenta',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 20.0,
                ),
                _crearNombre(bloc),
                SizedBox(
                  height: 10.0,
                ),
                _crearApellidos(bloc),
                SizedBox(
                  height: 10.0,
                ),
                _crearEmail(bloc),
                SizedBox(
                  height: 10.0,
                ),
                _crearPassword(bloc),
                
                SizedBox(
                  height: 30.0,
                ),
                _crearBoton(bloc)
              ],
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
            child: Text('¿Ya tienes una cuenta?')
          ),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _crearEmail(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                suffixIcon: Icon(Icons.email, color: Colors.blueAccent),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correo electrónico',
                counterText: snapshot.data,
                errorText: snapshot.error
              ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }
   Widget _crearNombre(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.nombreStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                suffixIcon: Icon(Icons.person, color: Colors.blueAccent),
                labelText: 'Nombre',
                counterText: snapshot.data,
                errorText: snapshot.error
              ),
            onChanged: bloc.changeNombre,
          ),
        );
      },
    );
  }
   Widget _crearApellidos(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.apellidosStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                suffixIcon: Icon(Icons.note, color: Colors.blueAccent),
                labelText: 'Apellidos',
                counterText: snapshot.data,
                errorText: snapshot.error
              ),
            onChanged: bloc.changeApellido,
          ),
        );
      },
    );
  }

  Widget _crearPassword(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              suffixIcon: Icon(Icons.lock, color: Colors.blueAccent),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearBoton(RegistroBloc bloc) {

    // formValidStream
    // snapshot.hasdata true ? algositure : algosifalse

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
          child: Text('Crear'),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 0.0,
        color: Colors.blueAccent,
        textColor: Colors.white,
        onPressed: snapshot.hasData ? () => _register(bloc, context) : null
        );
      } 
    );
  }

  _register(RegistroBloc bloc, BuildContext context) async{
    final pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(message: 'Registrando usuario');
    pr.show();
    ResponseModel response =  await usuarioProvider.nuevoUsuario(bloc.nombre, bloc.apellidos, bloc.email, bloc.password);
    pr.hide();
    print('email: ${bloc.email}',);
    print('password: ${bloc.password}',);
    _mostrarAlerta(context,response);
    // Navigator.pushNamed(context, 'home');

  }

  Widget _mostrarAlerta(BuildContext context, ResponseModel response) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          title: response.success ? Icon(Icons.check_circle, color: Colors.green, size: 50.0,) : Icon(Icons.error, color: Colors.red, size: 50.0,),
          content: Text(response.message),
          actions: <Widget>[
            FlatButton(
              child: response.success? Text('Login') : Text('Ok'),
              onPressed: (){
                if(response.success){
                  Navigator.pushReplacementNamed(context, 'login');
                }else{
                  Navigator.pop(context);
                }
              },
            )
          ],
        );
      }
    );
  }
}
