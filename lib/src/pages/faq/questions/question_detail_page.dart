import 'package:flutter/material.dart';
import 'package:form_validation/src/models/post_model.dart';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:form_validation/src/providers/publicacion_provider.dart';
import 'package:form_validation/src/widgets/commentsWidget.dart';
import 'package:form_validation/src/widgets/userCard.dart';
import 'package:like_button/like_button.dart';


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

  @override
  void initState() {
    like = false;
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Pregunta'),
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

}