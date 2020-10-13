import 'package:flutter/material.dart';
import 'package:form_validation/src/models/post_model.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:form_validation/src/providers/publicacion_provider.dart';
import 'package:form_validation/src/widgets/commentsWidget.dart';
import 'package:form_validation/src/widgets/flushbar_feedback.dart';
import 'package:form_validation/src/widgets/userCard.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class QuestionDetailPage extends StatefulWidget {

  final Post post;

  QuestionDetailPage({@required this.post});

  @override
  _QuestionDetailPageState createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  bool like;
  final postProvider = new PostProvider();
  final prefs = PreferenciasUsuario();
  bool isAdmin = false;
  bool _callInProgresss = false;
  @override
  void initState() {
    like = false;
    this.isAdmin = prefs.isAdmin;
    for(final user in this.widget.post.users){
      if(prefs.idUser == user){
        like = true;
        break;
      }
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      opacity: 0.5,
      progressIndicator: CircularProgressIndicator(),
      inAsyncCall: _callInProgresss,
      dismissible: false,
      child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Pregunta'),
        actions: <Widget>[
          this.widget.post.idUser.id == prefs.idUser || this.isAdmin ?
          IconButton(icon: Icon(Icons.delete), onPressed: (){
            print('borrar post');
            _deletePostDialog(context);
          })
          : Container()
      
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: _crearPost(context),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Comentarios'),
        icon: Icon(Icons.comment),  
        onPressed: (){
          navigateToComments(context);
        }
      ),
      )
    );
  }

  Widget _crearPost(BuildContext context){
    return Container(
      margin: EdgeInsets.all(10.0),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text(this.widget.post.titulo, style: TextStyle(fontSize: 20.0),textAlign: TextAlign.justify,)),
              SizedBox(width: 10.0,),
              _likeButton(),
            ],
          ),
          SizedBox(height: 20.0,),
          Text('Usuario', style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),), 
          SizedBox(height: 10.0,),
          UserCard(user: this.widget.post.idUser, fecha: this.widget.post.fecha,),
          SizedBox(height: 20.0,),
          Text('Descripción', style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),), 
          SizedBox(height: 10.0,),
          Text(this.widget.post.mensaje, style: TextStyle(fontSize: 16.0),),


        ],
      ),
    );
  }

  Widget _likeButton(){
    return LikeButton(
      size: 35.0,
      circleColor:
          CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Colors.yellow[700],
        dotSecondaryColor: Colors.blueAccent,
      ),
      likeBuilder: (like) {
        return Icon(
          Icons.star,
          color: like ? Colors.yellow[700] : Colors.grey,
          size: 35.0,
        );
      },
      likeCount: this.widget.post.users.length,
      countBuilder: (int count, bool isLiked, String text) {
        var color = Colors.grey;
        Widget result;
        result = Text(
          text,
          style: TextStyle(color: color),
        );
        return result;
      },
      onTap: (like){
        return postProvider.likePost(this.widget.post.id);
      },
      isLiked: like,
    );
  }

  navigateToComments(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {  return CommentWidget(idPost: this.widget.post.id );}));
  }

  _deletePostDialog(BuildContext context) async{
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
              Expanded(child: Text('¿Quiéres eliminar esta pregunta?'))
            ],
          ),
          content: Text('Esta acción eliminará esta pregunta permanentemente'),
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
      setState(() {
        _callInProgresss = true; 
        _deletePost(context);
      });
    }
  }

  _deletePost(BuildContext context) async{
    ResponseModel res = await postProvider.deletePost(this.widget.post.id);
    if(res.success){
      Navigator.popUntil(context, ModalRoute.withName('questions'));
    }else{
      setState(() {
        _callInProgresss = false;
        FlushbarFeedback.flushbar_feedback(context, res.message, ' ', res.success);
      });
    }
  }

}