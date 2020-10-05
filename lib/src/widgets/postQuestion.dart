import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/enums/enum_apis.dart';
import 'package:form_validation/src/models/post_model.dart';
import 'package:form_validation/src/pages/faq/questions/question_detail_page.dart';
import 'package:intl/intl.dart';

class PostQuestion extends StatelessWidget {

  final List<Post> posts;
  final Function siguientePagina;

  PostQuestion({@required this.posts, @required this.siguientePagina});

  final _scrollController = new ScrollController();
  
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
          this.siguientePagina();
      }
    });
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _getPage1,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return _tarjetaPost(posts[index], context);
          },
        ),
      ),
    );
  }

  Widget _tarjetaPost(Post post, BuildContext context) {
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(post.fecha);
    return FadeIn(
      child: Card(
        elevation: 10,
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: CircleAvatar(
              backgroundImage: NetworkImage(ApisEnum.url + ApisEnum.getImage + post.idUser.image),
              radius: 22.0,
            ),
          title: Text(post.titulo, overflow: TextOverflow.ellipsis, maxLines: 2,),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(post.mensaje, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, maxLines: 2,),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.star, color: Colors.yellow[700],),
                        Text(post.users.length.toString())
                      ],
                    ),
                    // Row( mainAxisAlignment: MainAxisAlignment.spaceAround,children: <Widget>[Icon(Icons.comment, size: 20.0, color: Colors.blue,), Text('4')],),
                    Text(fechaFormateada , style: TextStyle(color:Colors.grey),),
                  ],
                ),
              ),
            ],
          ),
          
          onTap: () => {
            _navigateToQuestionPage(context, post)
          },
        )
      ),
    );
  }
  _navigateToQuestionPage(BuildContext context, Post post) async{
    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {  
      return QuestionDetailPage(post: post);
    }));
    posts.clear();
    this.siguientePagina(true);
  }

  Future<Null> _getPage1() async{
      posts.clear();
      this.siguientePagina(true);
  }
}