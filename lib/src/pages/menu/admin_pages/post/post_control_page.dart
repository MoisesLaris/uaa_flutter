import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:form_validation/src/models/post_model.dart';
import 'package:form_validation/src/pages/menu/admin_pages/post/post_new_edit.dart';
import 'package:form_validation/src/providers/publicacion_provider.dart';
import 'package:intl/intl.dart';


class PostControlPage extends StatefulWidget {
  bool isAdmin;

  PostControlPage(bool isAdmin){
    this.isAdmin = isAdmin;
  }
  @override
  _PostControlPageState createState() => _PostControlPageState();
}

class _PostControlPageState extends State<PostControlPage> {
  final postProvider = PostProvider();
  ScrollController _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    this.postProvider.getPostAdmin();
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
          await postProvider.getPostAdmin();
          setState(() {
            _isLoading = false;
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicaciones'),
        centerTitle: true,
        actions: this.widget.isAdmin ?  <Widget>[
          IconButton(icon: Icon(Icons.note_add), onPressed:() =>
            navigateToEditNewPage(context, true)
          )
        ] : []
      ),
      body: _futurePosts(context),
      floatingActionButton: SpeedDial(
          // both default to 16
          marginRight: 18,
          marginBottom: 20,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          visible: true,
          // If true user is forced to close dial manually 
          // by tapping main button and overlay is not rendered.
          closeManually: false,
          tooltip: 'Filtrar',
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.star),
              backgroundColor: Colors.yellow[700],
              label: 'Favoritos',
              onTap: () => print('FIRST CHILD')
            ),
            SpeedDialChild(
              child: Icon(Icons.calendar_today),
              backgroundColor: Colors.blue,
              label: 'Más recientes',
              onTap: () => print('SECOND CHILD'),
            ),
            SpeedDialChild(
              child: Icon(Icons.timer),
              backgroundColor: Colors.green,
              label: 'Primeras publicaciones',
              onTap: () => print('THIRD CHILD'),
            ),
          ],
        ),
    );
  }

  Widget _futurePosts(BuildContext context){
    return StreamBuilder(
      stream: postProvider.postStream,
      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot){
        print(snapshot);
        if(snapshot.connectionState == ConnectionState.active){
          if(snapshot.hasData){
            if(snapshot.data.length > 0){
              return Stack(children: <Widget>[ FadeIn(child: _crearCards(context, snapshot.data)), _crearLoading()]);
            }else{
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(child: Text('Ninguna publicación'),),
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

  Widget _crearCards(BuildContext context, List<Post> listaPublicaciones){
    return RefreshIndicator(
      onRefresh: (){
          return postProvider.getPostAdmin(true);
        },
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: listaPublicaciones.length,
        controller: _scrollController,
        itemBuilder: (context, index){
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/uaa.png'),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(listaPublicaciones[index].titulo),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.star, color: Colors.yellow[700],),
                              Text(listaPublicaciones[index].users.length.toString())
                            ],
                          ),
                          // Row( mainAxisAlignment: MainAxisAlignment.spaceAround,children: <Widget>[Icon(Icons.comment, size: 20.0, color: Colors.blue,), Text('4')],),
                          Text(DateFormat('dd/MM/yyyy').format(listaPublicaciones[index].fecha) , style: TextStyle(color:Colors.grey),),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () => navigateToEditNewPage(context, false, listaPublicaciones[index])
              ),
            ),
          );
        },
      ),
    );
  }

  navigateToEditNewPage(BuildContext context, bool isNewPost, [Post post]) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {  
      if(this.widget.isAdmin){
        if(isNewPost) 
          return PostNewEdit.newPost();
        else
          return PostNewEdit(post: post);
      }else{
        return PostNewEdit.onlyView(post);
      }
      
    }));
      setState(() {
        postProvider.getPostAdmin(true);
      });
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

}
