import 'package:flutter/material.dart';
import 'package:form_validation/src/models/post_model.dart';
import 'package:form_validation/src/pages/menu/admin_pages/post/post_new_edit.dart';
import 'package:form_validation/src/providers/publicacion_provider.dart';

class PostControlPage extends StatefulWidget {
  @override
  _PostControlPageState createState() => _PostControlPageState();
}

class _PostControlPageState extends State<PostControlPage> {

  final postProvider = PostProvider();
  Future<List<Post>> futurePost;
  List<Post> listaPublicaciones;

  @override
  void initState() {
    this.futurePost = this.postProvider.getPost();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicaciones'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.note_add), onPressed:() =>
            navigateToEditNewPage(context, true)
          )
        ]
      ),
      body: _futurePosts(),
    );
  }

  Widget _futurePosts(){
    return FutureBuilder(
      future: this.futurePost,
      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              listaPublicaciones= snapshot.data;   
              return _crearCards(context);
            }else{
              return Center(child: Text('Ninguna publicación encontrada'),);
            }
        }else{
            return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  Widget _crearCards(context){
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: listaPublicaciones.length,
      itemBuilder: (context, index){
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(listaPublicaciones[index].titulo),
              subtitle: Text(listaPublicaciones[index].mensaje),
              onTap: () => navigateToEditNewPage(context, false, listaPublicaciones[index])
            ),
          ),
        );
      },
    );
  }

  navigateToEditNewPage(BuildContext context, bool isNewPost, [Post post]) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {  
      if(isNewPost) 
        return PostNewEdit.newPost();
      else
        return PostNewEdit(post: post);
    }));
      setState(() {
        futurePost = postProvider.getPost(true);
      });
  }

}
