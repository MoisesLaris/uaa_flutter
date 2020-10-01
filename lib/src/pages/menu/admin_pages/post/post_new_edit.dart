import 'package:flutter/material.dart';
import 'package:form_validation/src/models/post_model.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/providers/publicacion_provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quill_delta/quill_delta.dart';
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
  final _postProvider = new PostProvider();
  bool _callInProgress = false;



  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
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
                _deletePostType(this.widget.post.id, context);
              }
          })
        ]
      ),
      body: _form(),
    ) 
  );
  }

  Widget _form(){
    return ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
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
    final Delta delta = Delta()..insert("Zefyr Quick Start\n");
    return NotusDocument.fromDelta(delta);
  }
}