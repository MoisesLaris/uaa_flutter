import 'package:flutter/material.dart';
import 'package:form_validation/enums/enum_apis.dart';
import 'package:form_validation/src/models/user_model.dart';
import 'package:intl/intl.dart';

class UserCard extends StatelessWidget {
  final User user;
  final DateTime fecha;
  const UserCard({@required this.user, this.fecha, });


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _card(),
        _iconUser()
      ],
    );
  }

  Widget _card(){
    return Container(
      height: 70.0,
      margin: EdgeInsets.only(left: 25.0,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [
            0.2,
            0.8,
          ],
        colors: [
          Colors.blue[200],
          Colors.blue,
   
        ])
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(this.user.nombre + ' ' + this.user.apellidos, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white)),
            Row(
              children: <Widget>[
                Text('Fecha: ' + DateFormat('dd/MM/yyyy').format(this.fecha), style: TextStyle(color: Colors.white))
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget _iconUser(){
    return Positioned(
      bottom: 5.0,
      child: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(ApisEnum.url + ApisEnum.getImage + this.user.image),
      ),
    );
  }
}