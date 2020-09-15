import 'package:flutter/material.dart';
import 'package:form_validation/src/models/user_model.dart';
import 'package:form_validation/src/pages/menu/admin_pages/users/user_edit_page.dart';
import 'package:form_validation/src/providers/usuario_provider.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final userProvider = new UsuarioProvider();

  bool sort;
  Future<List<User>> futureUsers;
  List<User> users = [];

  void initState(){
    sort = false;
    futureUsers = userProvider.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Usuarios'),
          actions: <Widget>[
          IconButton(icon: Icon(Icons.person_add), onPressed: () {
            navigateToAddUser(context);
          })
        ],
        ),
        body: FutureBuilder(
          future: futureUsers,
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                this.users = snapshot.data;   
                return dataBody(context);
              }else{
                return Center(child: Text('¡Error! 404'),);
              }
            }else{
                return Center(child: CircularProgressIndicator(),);
            }
          },
        ));
  }

  onSortNombreColumn(int columnIndex, bool ascending){
    if(columnIndex == 0){
      if(ascending){
        users.sort((a,b) => a.nombre.compareTo(b.nombre));
      }else{
        users.sort((a,b) => b.nombre.compareTo(a.nombre));
      }
    }
  }
  onSortTipoColumn(int columnIndex, bool ascending){
    if(columnIndex == 1){
      if(ascending){
        users.sort((a,b) => a.isAdmin ? 1 : -1);
      }else{
        users.sort((a,b) => b.isAdmin ? 1 : -1);
      }
    }
  }

  Widget dataBody(BuildContext context) {
    final style1 = TextStyle(color: Colors.blueAccent);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortAscending: sort,
                  sortColumnIndex: 1,
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(
                        label: Text('Email',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)), numeric: false, tooltip: 'Apellidos'),
                    DataColumn(
                        label: Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        numeric: false,
                        tooltip: 'Admin',
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });
                          onSortTipoColumn(columnIndex, ascending);
                        },
                      ),
                  ],
                  rows: users.map(
                    (user) => DataRow(
                      onSelectChanged: (selected) {
                        navigateToEdit(context,user);
                      },
                      cells:[
                        //DataCell(Text(user.nombre)/* , showEditIcon: true */),
                        DataCell(Text(user.email)),
                        DataCell(user.isAdmin ? Text('Administrador',overflow: TextOverflow.ellipsis, style: style1) : Text('Usuario')),
                      ]
                    )
                  ).toList(),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  navigateToEdit(BuildContext context, User user) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {  return UserEditPage(user: user,); }));
      setState(() {
        futureUsers = userProvider.getUsers();
      });
  }
  navigateToAddUser(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {  return UserEditPage.newUser(); }));
    setState(() {
      futureUsers = userProvider.getUsers();
    });
  }
}
