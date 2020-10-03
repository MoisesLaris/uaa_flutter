import 'package:flutter/material.dart';
import 'package:form_validation/src/models/postType_model.dart';
import 'package:form_validation/src/models/post_model.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/pages/menu/admin_pages/post/zefyr_image_delegate.dart';
import 'package:form_validation/src/providers/publicacion_provider.dart';
import 'package:form_validation/src/providers/tipoPublicacion_provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quill_delta/quill_delta.dart';
import 'dart:convert';
import 'package:zefyr/zefyr.dart';

class PostNewEdit extends StatefulWidget {
  Post post;
  bool newPost = false;
  PostNewEdit({@required this.post});
  PostNewEdit.newPost(){
    this.post = new Post.empty();
    this.newPost = true;
  }
  @override
  _PostNewEditState createState() => _PostNewEditState();
}

class _PostNewEditState extends State<PostNewEdit> {
  ZefyrController _controller;
  FocusNode _focusNode;
  //Providers
  final PostProvider postProvider = new PostProvider();
  final PostTypeProvider postTypeProvider = new PostTypeProvider();
  
  //Futures y listas -> Dropdown
  Future<List<PostType>> futurePostTypeList;
  List<PostType> postTypeList;
  PostType postTypeSelected = null;

  final _myController = TextEditingController();
  bool _callInProgress = false;
  

  @override
  void initState() {
    super.initState();
    futurePostTypeList = postTypeProvider.getPostTypes();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    _myController.text = this.widget.post.titulo;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _callInProgress,
      opacity: 0.5,      
      dismissible: false,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
      appBar: AppBar(
        title: Text('Publicación'),
        centerTitle: true,
        actions: <Widget>[
          this.widget.newPost ? 
          IconButton(icon: Icon(Icons.save), onPressed: () {
            this._saveDocument(context);
          }) :
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
                _deletePostType(this.widget.post.id, context);
              }
          }),
        ]
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(child: _inputTitle(), flex: 3,),
              VerticalDivider(),
              Expanded(child: _selectType(context), flex: 2,)
            ],
          ),
          Divider(thickness: 1.0,),
          Expanded(child: _form()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: (){
          _saveDocument(context);
        }
      ),
    ) 
  );
  }

  Widget _form(){
    return ZefyrScaffold(
        child: ZefyrEditor(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(10),
          controller: _controller,
          focusNode: _focusNode,
          imageDelegate: MyAppZefyrImageDelegate(postProvider),
          mode: ZefyrMode.edit,
          autofocus: false,
        ),
      );
  }



  _deletePostType(dynamic id, BuildContext context) async{
    setState(() {
      _callInProgress = true;
    });
    // ResponseModel res = await this._postProvider.deletePostType(id);
    // if(res.success){

    //   Navigator.popUntil(context, ModalRoute.withName('postType'));
    // }else{

    // }
  }

  NotusDocument _loadDocument() {
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    if(this.widget.newPost){
      final Delta delta = Delta()..insert("Descripción\n");
      return NotusDocument.fromDelta(delta);
    }else{
      return NotusDocument.fromJson(jsonDecode(this.widget.post.mensaje));
    }

    
  }

  void _saveDocument(BuildContext context) async{ //Aqui se va a mandar llamar la api
    if(_myController.text.isEmpty || this.postTypeSelected == null){
      return;
    }
    setState(() {

    });
    String contents = jsonEncode(_controller.document);
    ResponseModel respuesta;
    if(!this.widget.newPost){
      respuesta = await postProvider.editPost(this.widget.post.id, _myController.text, contents, false, postTypeSelected);
    }else{
      respuesta = await postProvider.newPost(_myController.text, contents, false, postTypeSelected);
    }
    print(respuesta.message);
  }






  Widget _inputTitle(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: _myController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Añade un título ...',
          hintStyle: TextStyle(fontSize: 14.0),
          errorText: _myController.text.isEmpty ? 'Ingrese título' : null,
          errorStyle: TextStyle(fontSize: 10.0),  
        ),
      ),
    );
  }

  Widget _selectType(BuildContext context){
    return FutureBuilder(
      future: futurePostTypeList,
      builder: (BuildContext context, AsyncSnapshot<List<PostType>> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              print('me redibujo perro');
              postTypeList = snapshot.data;
              if(postTypeSelected == null){
                if(this.widget.newPost){
                  postTypeSelected = postTypeList[0];   
                }else{
                  postTypeList.forEach((element) {
                    if(element.id == this.widget.post.tipoPublicacion.id){
                      print(element.nombre);
                      postTypeSelected = element;
                    }
                  });
                }
              }
              return _crearDropdown();
            }else{
              return Center(child: Text('Tipos publicación no encontradas', overflow: TextOverflow.ellipsis,),);
            }
        }else{
            return Center(child: CircularProgressIndicator(),);
        }
      },
    );
    
    
    
  }
  
  Widget _crearDropdown(){
    
    final dropdown = DropdownButton<PostType>(
      value: postTypeSelected,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.blueAccent),
      underline: Container(
        height: 1,
        color: Colors.blueAccent,
      ),
      onChanged: (PostType newValue) {
        setState(() {
          postTypeSelected = newValue;
        });
      },
      items: postTypeList.map<DropdownMenuItem<PostType>>((PostType postType) {
        return DropdownMenuItem<PostType>(
          value: postType,
          child: Text(postType.nombre),
        );
      }).toList(),
    );
    return dropdown;

    
  }

}