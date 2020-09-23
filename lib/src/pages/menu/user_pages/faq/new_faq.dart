import 'package:flutter/material.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/providers/publicacion_provider.dart';
import 'package:form_validation/src/widgets/flushbar_feedback.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NewFAQ extends StatefulWidget {
  @override
  _NewFAQState createState() => _NewFAQState();
}

class _NewFAQState extends State<NewFAQ> {

  final _formKey = GlobalKey<FormState>();
  PostProvider _postProvider = PostProvider();
  bool _callInProgress = false;

  String _titulo = '';
  String _body = '';

  
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('¿Tienes una pregunta?'),
    //     centerTitle: true,
    //   ),
    //   body: _form()
    // );
    return ModalProgressHUD(
      inAsyncCall: _callInProgress,
      opacity: 0.5,      
      dismissible: false,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('¿Tienes una pregunta?'),
          centerTitle: true,
        ),
        body: _form(context)
      ),
    );
  }

  Widget _form(BuildContext context){
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
              child: Text('¿Tienes alguna pregunta?', style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),),
            ),
            _inputTitulo(),
            _inputBody(),
            _saveButton(context)
          ],
        ),
      ),
    );
  }

  Widget _inputTitulo(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        validator: (value) {
          if(value.isEmpty){
            return 'Ingrese pregunta';
          }
          return null;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            suffixIcon: Icon(Icons.question_answer, color: Colors.blue),
            hintText: 'Ingresa pregunta',
            labelText: 'Titulo',
            helperText: 'Sé específico con tu pregunta'
          ),
        onSaved: (value){
          this._titulo = value;
        },
      ),
    );
  }

  Widget _inputBody(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        maxLines: 5,
        validator: (value) {
          if(value.isEmpty){
            return 'Ingrese descripcion';
          }
          return null;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
            ),
            // suffixIcon: Icon(Icons.comment, color: Colors.blue),
            hintText: 'Descripción',
            labelText: 'Descripción',
            helperText: 'Incluye información relevante para que alguien resuelva tu duda'
          ),
        onSaved: (value){
          this._body = value;
        },
      ),
    );
  }

  Widget _saveButton(BuildContext context){
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
          if(_callInProgress){
            return;
          }
          if(_formKey.currentState.validate()){
            setState(() {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              _callInProgress = true;
              _formKey.currentState.save();
              _fnPostNewQuestion();
            });
            

          }
        },
      ),
    );
  }

  _fnPostNewQuestion() async{
    ResponseModel res = await _postProvider.newPost(_titulo, _body, false);
    FlushbarFeedback.flushbar_feedback(context, res.message, ' ', res.success);
    if(res.success) this._formKey.currentState.reset();
    setState(() {
      this._callInProgress = false;
    });
  }


}