import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validation/enums/enum_apis.dart';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:form_validation/src/providers/usuario_provider.dart';
import 'package:form_validation/src/widgets/flushbar_feedback.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final prefs = PreferenciasUsuario();
  final usuarioProvider = UsuarioProvider();
  final picker = ImagePicker();
  File image = null;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              _crearImage(context),
              SizedBox(
                height: 10.0,
              ),
              _crearSubtitle(),
              SizedBox(
                height: 20.0,
              ),
              Divider(),
              _cuenta(),
              Divider(),
              _salir(context),
            ],
          )),
    );
  }

  Widget _crearSubtitle() {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            prefs.nombre + ' ' + prefs.apellidos,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          Text(
            prefs.email,
            style: TextStyle(fontSize: 16.0, color: Colors.blue),
          )
        ],
      ),
    );
  }

  Widget _crearImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsetsDirectional.only(top: 20.0),
      height: size.height * 0.25,
      width: size.height * 0.25,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.fill,
            image: this.image == null
                ? NetworkImage(prefs.image != ''
                    ? ApisEnum.url + ApisEnum.getImage + prefs.image
                    : 'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png')
                : FileImage(this.image)
          ),
      ),
      child: GestureDetector(
        onTap: () => _seleccionarFoto(context),
      ),
    );
  }

  Widget _cuenta() {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        leading: Icon(
          Icons.account_circle,
          size: 30.0,
        ),
        title: Text('Cuenta'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {},
      ),
    );
  }

  _seleccionarFoto(BuildContext context) async {
    var img = await picker.getImage(source: ImageSource.gallery);
    if (img != null) {
      final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
      pr.style(
        message: 'Subiendo imagen',
        insetAnimCurve: Curves.easeInOut,
      );
      await pr.show();
      //Subir imagen
      
      final res = await usuarioProvider.uploadImage(File(img.path));
      await pr.hide();
      FlushbarFeedback.flushbar_feedback(
          context, 'Imagen', res.message, res.success);
    }
    setState(() {
      if (img != null) {
        this.image = File(img.path);
      }
    });
  }

  _salir(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        leading: Icon(
          Icons.exit_to_app,
          size: 30.0,
        ),
        title: Text('Salir'),
        onTap: () {
          setState(() {
            usuarioProvider.logout(context);
          });
          
        },
      ),
    );
  }
}
