import 'package:flutter/material.dart';
import 'package:form_validation/src/models/post_model.dart';
import 'package:form_validation/src/pages/faq/questions/question_detail_page.dart';
import 'package:form_validation/src/pages/menu/admin_pages/post/post_new_edit.dart';
import 'package:form_validation/src/providers/publicacion_provider.dart';

class DataSearch extends SearchDelegate {
  bool isQuestion = false;
  String seleccion = '';
  final postProvider = new PostProvider();

  DataSearch();
  DataSearch.isQuestion(){
    this.isQuestion = true;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    //Las acciones de nuestro appBar  
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Icono a la izquierda del appBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context,null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //Crea los resultados que vamos a mostrar
    return FutureBuilder(
      future: isQuestion ? postProvider.buscarQuestion(query) : postProvider.buscarPost(query),
      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
        print(snapshot.data);
        if(snapshot.hasData){

          final posts = snapshot.data;
          return ListView(
            children: posts.map((post) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/uaa.png'),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(post.titulo),
                trailing: Row(mainAxisSize: MainAxisSize.min ,children: <Widget>[Icon(Icons.star, color: Colors.yellow[700],), Text(post.users.length.toString(),overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey),)],),
                onTap: (){
                  close(context,null);
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {  
                    if(isQuestion){
                      return QuestionDetailPage(post: post);
                    }else{
                      return PostNewEdit.onlyView(post);
                    }
                  }));
                },
              );
            }).toList()
          );

        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Las sugerencias que aparencen cuando la persona escribe
      print(query);

    if(query.isEmpty){
      return Container();
    }
    return FutureBuilder(
      future: isQuestion ? postProvider.buscarQuestion(query) : postProvider.buscarPost(query),
      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
        print(snapshot.data);
        if(snapshot.hasData){

          final posts = snapshot.data;
          return ListView(
            children: posts.map((post) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/uaa.png'),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(post.titulo),
                trailing: Row(mainAxisSize: MainAxisSize.min ,children: <Widget>[Icon(Icons.star, color: Colors.yellow[700],), Text(post.users.length.toString(),overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey),)],),
                onTap: (){
                  close(context,null);
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {  
                    if(isQuestion){
                      return QuestionDetailPage(post: post);
                    }else{
                      return PostNewEdit.onlyView(post);
                    }
                  }));
                },
              );
            }).toList()
          );

        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );



    // final listaSugerida = (query.isEmpty) ? peliculasRecientes : peliculas.where((pelicula) => pelicula.toLowerCase().startsWith(query.toLowerCase())).toList();

    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (context, i) {
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(listaSugerida[i]),
    //       onTap: () {
    //         seleccion = listaSugerida[i];
    //         showResults(context);
    //       },
    //     );
    //   }
    // );
  }
}
