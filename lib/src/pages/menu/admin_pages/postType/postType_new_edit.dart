import 'package:flutter/material.dart';
import 'package:form_validation/src/models/postType_model.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/providers/tipoPublicacion_provider.dart';
import 'package:form_validation/src/widgets/flushbar_feedback.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PostTypeNewEdit extends StatefulWidget {
  PostType postType;
  bool newPostType = false;
  PostTypeNewEdit({@required this.postType});
  PostTypeNewEdit.newPostType(){
    this.postType = new PostType.empty();
    this.newPostType = true;
  }
  @override
  _PostTypeNewEditState createState() => _PostTypeNewEditState();
}

class _PostTypeNewEditState extends State<PostTypeNewEdit> {
  final _postTypeProvider = new PostTypeProvider();
  final _formKey = GlobalKey<FormState>();
  bool _deleteInProgress = false;
  @override
  void initState() { 
    //Codigo de inicio
    print('id' + this.widget.postType.id);
    print('nombre' + this.widget.postType.nombre);
    print('descripcion' + this.widget.postType.descripcion);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( this.widget.newPostType ? 'Nuevo tipo publicación' : 'Editar tipo publicación', overflow: TextOverflow.ellipsis,),
        centerTitle: true,
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context, true);
          },
        ),
        actions: <Widget>[
          this.widget.newPostType ? 
          Container() :
          IconButton(icon: Icon(Icons.delete), onPressed:() async {
            final res = await showDialog(
              context: context,
              builder: (context){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    title: Row(
                      children: <Widget>[
                        Icon(Icons.delete, size: 35.0, color: Colors.red,),
                        SizedBox(width: 5.0,),
                        Expanded(child: Text('¿Quiéres eliminar este tipo publicación?'))
                      ],
                    ),
                    content: Text('Esta acción eliminará este tipo publicación permanentemente'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cancelar'),
                        onPressed: (){
                          Navigator.pop(context, false);
                        },
                      ),
                      FlatButton(
                        child: Text('Borrar', style: TextStyle(color: Colors.red),),
                        onPressed: (){
                          Navigator.pop(context, true);
                        },
                      )
                    ],
                  );
                }
              );
              if(res == true){
                _deletePostType(this.widget.postType.id, context);
              }
          })
        ]
      ),
      body: Container(
        child: _form()
      ),
    );
  }

  Widget _form(){
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
              child: Text(this.widget.newPostType ? 'Nuevo tipo publicación' : 'Editar tipo publicación', style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),),
            ),
            _inputNombre(),
            _inputDescripcion(),
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
        initialValue: this.widget.postType.nombre,
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
            suffixIcon: Icon(Icons.comment, color: Colors.blue),
            hintText: 'Ingresa tu nombre',
            labelText: 'Nombre',
          ),
        onSaved: (value){
          this.widget.postType.nombre = value;
        },
      ),
    );
  }

  Widget _inputDescripcion(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        initialValue: this.widget.postType.descripcion,
        validator: (value) {
          if(value.isEmpty){
            return 'Ingrese descripción';
          }
          return null;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            suffixIcon: Icon(Icons.description, color: Colors.blue),
            hintText: 'Ingresa descripción',
            labelText: 'Descripcion',
          ),
        onSaved: (value){
          this.widget.postType.descripcion = value;
        },
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
            _fnCreateEditPostType();

          }
        },
      ),
    );
  }

  void _fnCreateEditPostType() async{
    
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
      await pr.hide();

    if(this.widget.newPostType){
      pr.style( message: 'Creando tipo publicación', insetAnimCurve: Curves.easeInOut, );
      await pr.show();
      ResponseModel response = await _postTypeProvider.newPostType(this.widget.postType.nombre, this.widget.postType.descripcion);
      await pr.hide();
      _formKey.currentState.reset();
      FlushbarFeedback.flushbar_feedback(context, response.message, ' ', response.success);
    }else{
      pr.style( message: 'Editando tipo publicación', insetAnimCurve: Curves.easeInOut, );
      await pr.show();
      ResponseModel response = await _postTypeProvider.editPostType(this.widget.postType.id,this.widget.postType.nombre, this.widget.postType.descripcion);
      await pr.hide();
        FlushbarFeedback.flushbar_feedback(context, response.message, ' ', response.success);

    }
  }

  _deletePostType(dynamic id, BuildContext context) async{
    final pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style( message: 'Eliminando tipo publicación', insetAnimCurve: Curves.easeInOut, );
    await pr.show();
    ResponseModel res = await this._postTypeProvider.deletePostType(id);
    if(res.success){
      await pr.hide();
      Navigator.popUntil(context, ModalRoute.withName('postType'));
    }else{
      await pr.hide();
    }
  }
}