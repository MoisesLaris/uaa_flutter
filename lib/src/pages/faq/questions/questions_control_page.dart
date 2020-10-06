import 'package:flutter/material.dart';
import 'package:form_validation/src/providers/publicacion_provider.dart';
import 'package:form_validation/src/search/search_delegate.dart';
import 'package:form_validation/src/widgets/postQuestion.dart';


class QuestionControlPage extends StatefulWidget {

  String arguments;

  QuestionControlPage(String arguments){
    this.arguments = arguments;
  }
  @override
  _QuestionControlPageState createState() => _QuestionControlPageState();
}

class _QuestionControlPageState extends State<QuestionControlPage> {

  final postProvider = PostProvider();
  Function postFunction;

  @override
  Widget build(BuildContext context) {
    switch(this.widget.arguments){
      case 'mine': {
        postProvider.getMyQuestions();
        postFunction = postProvider.getMyQuestions;
      } 
      break;
      case 'favorites': {
        postProvider.getFavoriteQuestion();
        postFunction = postProvider.getFavoriteQuestion;
      }
      break;
      default: {
        postProvider.getPost();
        postFunction = postProvider.getPost;
      }
      break;
    }
    postProvider.getPost();
    print(this.widget.arguments);

    return Scaffold(
      appBar: AppBar(
        title: Text('Preguntas'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){
            showSearch(context: context, delegate: DataSearch.isQuestion());
          })
        ],
      ),
      body: _buildPreguntas(),
    );
  }

  Widget _buildPreguntas(){
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Container(
          //   padding: EdgeInsets.only(left:20),
          //   child: Text('Posts', style: Theme.of(context).textTheme.subtitle1,)
          // ),
          // SizedBox(
          //   height: 5.0,
          // ),
          StreamBuilder(
            stream: postProvider.postStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                print(snapshot.data);
                return PostQuestion(posts: snapshot.data, siguientePagina: this.postFunction);
              }else{
                return Center(child: CircularProgressIndicator());
              }
            }
          )
        ],
      ),
    );
  }

  
}
