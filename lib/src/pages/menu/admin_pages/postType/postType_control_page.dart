import 'package:flutter/material.dart';
import 'package:form_validation/src/models/postType_model.dart';
import 'package:form_validation/src/pages/menu/admin_pages/postType/postType_new_edit.dart';
import 'package:form_validation/src/providers/tipoPublicacion_provider.dart';

class PostTypeControl extends StatefulWidget {

  @override
  _PostTypeControlState createState() => _PostTypeControlState();
}

class _PostTypeControlState extends State<PostTypeControl> {
  final postTypeProvider = PostTypeProvider();
  Future<List<PostType>> futureListPostType;
  List<PostType> listaTiposPublicaciones;

  @override
  void initState() { 
    this.futureListPostType = postTypeProvider.getPostTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tipo publicación'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add_comment), onPressed:() =>
            navigateToEditNewPage(context, true)
          )
        ]
      ),
      body: Container(
        child: _futureBuilder(context),
      ),
    );
  }

  Widget _futureBuilder(BuildContext context){
    return FutureBuilder(
      future: this.futureListPostType,
      builder: (BuildContext context, AsyncSnapshot<List<PostType>> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              listaTiposPublicaciones = snapshot.data;   
              return _crearCards(context);
            }else{
              return Center(child: Text('¡Error! 404'),);
            }
        }else{
            return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  Widget _crearCards(BuildContext context){
    return ListView.builder(
      itemCount: listaTiposPublicaciones.length,
      itemBuilder: (context, index){
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Icon(
                Icons.insert_comment,
                color: Colors.blue,
              ),
              title: Text(listaTiposPublicaciones[index].nombre),
              subtitle: Text(listaTiposPublicaciones[index].descripcion),
              trailing: Icon(Icons.chevron_right),
              onTap: () => navigateToEditNewPage(context, false, listaTiposPublicaciones[index])
            ),
          ),
        );
      },
    );
  }

  navigateToEditNewPage(BuildContext context, bool isNewPost, [PostType postType]) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {  
      if(isNewPost) 
        return PostTypeNewEdit.newPostType();
      else
        return PostTypeNewEdit(postType: postType);
    }));
      setState(() {
        futureListPostType = postTypeProvider.getPostTypes();
      });
  }
}