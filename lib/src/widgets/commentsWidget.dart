import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/enums/enum_apis.dart';
import 'package:form_validation/src/models/comment_model.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:form_validation/src/providers/comentario_provider.dart';
import 'package:intl/intl.dart';


class CommentWidget extends StatefulWidget {
  final String idPost;
  const CommentWidget({
    @required this.idPost,
  });
  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final comentarioProvider = CommentProvider();
  final _myController = TextEditingController();
  bool _validate = false;
  bool _isLoading = false;
  final prefs = PreferenciasUsuario();

  ScrollController _scrollController;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    comentarioProvider.getComment(this.widget.idPost);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() async{
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
          setState(() {
            _isLoading = true;
          });
          await comentarioProvider.getComment(this.widget.idPost);
          setState(() {
            _isLoading = false;
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(child: _comments()),
            Divider(height: 1,),
            _commentBar(),
          ],
        ),
      ),
    );
  }

  Widget _comments(){
    return StreamBuilder(
      stream: comentarioProvider.commentStream,
      builder: (BuildContext context, AsyncSnapshot<List<Comment>> snapshot){
        print(snapshot.connectionState);
        if(snapshot.connectionState == ConnectionState.active){
          if(snapshot.hasData){
            if(snapshot.data.length > 0){
              return Stack(children: <Widget>[FadeIn(child:_crearComentarios(snapshot.data)), _crearLoading()],);
            }else{
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(child: Text('Ningún comentario'),),
              );
            }
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
        
      },
    );
  }

  _crearComentarios(List<Comment> comentarios){
    return RefreshIndicator(
        onRefresh: (){
          return comentarioProvider.getComment(this.widget.idPost, true);
        },
        child: ListView.builder(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: comentarios.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(ApisEnum.url + ApisEnum.getImage + comentarios[index].idUser.image),
                radius: 20.0,
              ),
              title: Text(comentarios[index].comentario),
              subtitle: Text('Fecha: ' + DateFormat('dd/MM/yyyy').format(comentarios[index].fecha)),
            ),
          );
        },
      ),
    );
  }
  Widget _crearLoading() {
    if (_isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[CircularProgressIndicator()]),
          SizedBox(
            height: 15.0,
          )
        ],
      );
    } else {
      return Container();
    }
  }

  // Column(children: snapshot.data.map((obj) => Text(obj.comentario)).toList());

  Widget _commentBar(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(ApisEnum.url + ApisEnum.getImage + this.prefs.image),
          ),
          SizedBox(width: 8.0,),
          Expanded(
            child: TextField(
              controller: _myController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Añade un comentario ...',
                hintStyle: TextStyle(fontSize: 14.0),
                errorText: _validate ? 'Ingrese comentario' : null,
                errorStyle: TextStyle(fontSize: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send), 
                  onPressed: (){
                    setState(() {
                      _myController.text.isEmpty ? _validate = true : _validate = false;
                      if(!_myController.text.isEmpty){
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        setState(() {
                          currentFocus.unfocus();
                        });
                        _sendComment();
                      }
                    });
                  }
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  _sendComment() async{
    ResponseModel response = await comentarioProvider.newComment(comentario: _myController.text, idPublicacion: this.widget.idPost);
    if(response.success){
      setState(() {
        _myController.clear();
        comentarioProvider.addComment(Comment.fromJsonMap(response.id));
      });
    }
  }
}