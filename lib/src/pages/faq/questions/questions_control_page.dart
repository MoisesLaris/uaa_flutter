import 'package:flutter/material.dart';
import 'package:form_validation/src/providers/publicacion_provider.dart';
import 'package:form_validation/src/widgets/postQuestion.dart';

class QuestionControlPage extends StatefulWidget {
  @override
  _QuestionControlPageState createState() => _QuestionControlPageState();
}

class _QuestionControlPageState extends State<QuestionControlPage> {

  final postProvider = PostProvider();

  @override
  Widget build(BuildContext context) {
    postProvider.getPost();
    return Scaffold(
      appBar: AppBar(
        title: Text('Preguntas'),
        centerTitle: true,
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
                return PostQuestion(posts: snapshot.data, siguientePagina: postProvider.getPost);
                // return MovieHorizontal(
                //   peliculas: snapshot.data,
                //   siguientePagina: peliculas.getPopulares,
                // );
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
