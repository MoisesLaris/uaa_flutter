import 'package:flutter/material.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/models/user_model.dart';
import 'package:form_validation/src/providers/usuario_provider.dart';
import 'package:form_validation/src/widgets/flushbar_feedback.dart';
import 'package:progress_dialog/progress_dialog.dart';

// ignore: must_be_immutable
class UserEditPage extends StatefulWidget {

  User user;
  bool newUser = false;
  UserEditPage({@required this.user});
  UserEditPage.newUser(){
    this.user = new User.empty();
    this.newUser = true;
  }

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {

  final usuarioProvider = UsuarioProvider();

  final _formKey = GlobalKey<FormState>();

  void initState(){

    if(this.widget.newUser){

    }else{
      this.widget.user.password = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( this.widget.newUser ? 'Nuevo usuario' : 'Editar usuario'),
        centerTitle: true,
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Container(
        child: _editForm()
      ),
    );
  }

  Widget _editForm(){
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
              child: Text(this.widget.newUser ? 'Nuevo usuario' : 'Editar usuario', style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),),
            ),
            _inputNombre(),
            _inputApellidos(),
            this.widget.newUser ? _inputEmail() : Container(),
            this.widget.newUser ? _inputPassword() : Container(),
            _inputIsAdmin(),
            _saveButton()
          ],
        ),
      ),
    );
  }

  Widget _inputNombre(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        initialValue: this.widget.user.nombre,
        validator: (value) {
          if(value.isEmpty){
            return 'Ingrese nombre';
          }
          return null;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            suffixIcon: Icon(Icons.person, color: Colors.blue),
            hintText: 'Ingresa tu nombre',
            labelText: 'Nombre',
          ),
        onSaved: (value){
          this.widget.user.nombre = value;
        },
      ),
    );
  }

  Widget _inputApellidos(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        initialValue: this.widget.user.apellidos,
        validator: (value) => value.isEmpty ? 'Ingrese apellido' : null,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            suffixIcon: Icon(Icons.perm_identity, color: Colors.blue),
            hintText: 'Ingresa apellido',
            labelText: 'Apellido',
          ),
        onSaved: (value){
          this.widget.user.apellidos = value;
        },
      ),
    );
  }

  Widget _inputEmail(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        initialValue: this.widget.user.email,
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          suffixIcon: Icon(Icons.email, color: Colors.blueAccent),
          hintText: 'ejemplo@correo.com',
          labelText: 'Correo electrónico',
          // errorText: _validEmail ? null : 'Email no valido'
        ),
        onSaved: (value){
          this.widget.user.email = value;
        },
      ),
    );
  }

  Widget _inputPassword(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        obscureText: true,
        validator: (value) => value.length > 6 ? null : 'Ingrese mas de 6 caracteres',
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          suffixIcon: Icon(Icons.lock, color: Colors.blueAccent),
          labelText: 'Contraseña',
        ),
        onSaved: (value){
          this.widget.user.password = value;
        },
      ),
    );
  }

  Widget _inputIsAdmin(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: CheckboxListTile(
        value: this.widget.user.isAdmin,
        onChanged: ((data) {
          setState(() {
            this.widget.user.isAdmin = data;
          });
        }),
        title: Text("¿Es administrador?"),
      ),
    );
  }

  Widget _saveButton(){
    return Container(
      width: double.infinity,
      height: 70.0,
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: RaisedButton(
        child: Text('Guardar', style: TextStyle(fontSize: 16.0 ,color: Colors.white),),
        color: Colors.blue,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: (){
          if(_formKey.currentState.validate()){

            _formKey.currentState.save();
            _fnCreateEditUser();
            print('nombre:' + this.widget.user.nombre);
            print('apellido:' + this.widget.user.apellidos);
            print('email:' + this.widget.user.email);
            print('password:' + this.widget.user.password);
            print('isAdmin:' + this.widget.user.isAdmin.toString());

          }
        },
      ),
    );
  }

  void _fnCreateEditUser() async{
    
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
      await pr.hide();

    if(this.widget.newUser){
      pr.style( message: 'Creando usuario', insetAnimCurve: Curves.easeInOut, );
      await pr.show();
      ResponseModel response = await usuarioProvider.nuevoUsuarioAdmin(this.widget.user.nombre, this.widget.user.apellidos, this.widget.user.email, this.widget.user.password, this.widget.user.isAdmin);
      await pr.hide();
      FlushbarFeedback.flushbar_feedback(context, response.message, ' ', response.success);

    }else{
      pr.style( message: 'Editando usuario', insetAnimCurve: Curves.easeInOut, );
      await pr.show();
      ResponseModel response = await usuarioProvider.editUser(this.widget.user);
      await pr.hide();
      FlushbarFeedback.flushbar_feedback(context, response.message, ' ', response.success);
    }
  }

}