import 'package:flutter/material.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/pages/home_page.dart';
import 'package:form_validation/src/providers/usuario_provider.dart';
import 'package:form_validation/src/widgets/flushbar_feedback.dart';
import 'package:form_validation/theme/theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart' as providerDart;

class LoginPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();
  final _formKey = GlobalKey<FormState>();
  
  String _correo = '';
  String _password = '';

  bool isDark = false;
  

  @override
  Widget build(BuildContext context) {
    this.isDark = providerDart.Provider.of<ThemeChanger>(context).darkTheme;
    return Scaffold(
      body: FutureBuilder(
        future: usuarioProvider.verifyJWT(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else
            return _redireccion(context, snapshot.data);
        },
      ),
    );
  }

  Widget _redireccion(BuildContext context, bool redirect) {
    if (redirect) {
      return HomePage();
    }
    return Stack(
      children: <Widget>[_crearFondo(context), _loginForm(context)],
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0),
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
          left: 30.0,
          child: circulo,
        ),
        Positioned(
          top: -40.0,
          left: -30.0,
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
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
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
                  color: this.isDark ? Colors.grey[800] : Colors.white,
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
                    'Ingreso',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  _crearEmail(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _crearPassword(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _crearBoton(context)
                ],
              ),
            ),
            FlatButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'registro'),
                child: Text('Crear una nueva cuenta')),
            SizedBox(
              height: 100.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _crearEmail() {
    return Container(
      padding: EdgeInsets.symmetric
      (horizontal: 20.0),
      child: TextFormField(
        validator: (value){
          Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regExp = new RegExp(pattern);
          if(!regExp.hasMatch(value)){
            return 'Ingrese correo valido';
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            suffixIcon: Icon(Icons.email),
            hintText: 'ejemplo@correo.com',
            labelText: 'Correo electrónico',
          ),
        onSaved: (value){
          this._correo = value;
        },
      ),
    );
  }

  Widget _crearPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        obscureText: true,
        validator: (value) => value.length > 6 ? null : 'Ingrese mas de 6 caracteres',
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          suffixIcon: Icon(Icons.lock),
          labelText: 'Contraseña',
        ),
        onSaved: (value){
          this._password = value;
        },
      ),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.0,
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: RaisedButton(
        child: Text('Enviar', style: TextStyle(fontSize: 16.0 ,color: Colors.white),),
        color: Colors.blue,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: (){
          if(_formKey.currentState.validate()){
  
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              _formKey.currentState.save();
              _login(context);
            }
          }
        )
      );
            

  }

  _login(BuildContext context) async {
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
      message: 'Iniciando sessión',
      insetAnimCurve: Curves.easeInOut,
    );
    await pr.show();
    ResponseModel responseModel =
        await this.usuarioProvider.login(this._correo, this._password);
    if (responseModel.success) {
      pr.update(message: responseModel.message);
      await pr.hide();
      Navigator.pushReplacementNamed(context, 'home');
      FlushbarFeedback.flushbar_feedback(context, 'Bienvenido', ' ', true);
    } else {
      await pr.hide();
      FlushbarFeedback.flushbar_feedback(
          context, responseModel.message, ' ', false);
    }
    // Navigator.pushNamed(context, 'home');
  }
}
