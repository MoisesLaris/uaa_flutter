import 'package:flutter/material.dart';
import 'package:form_validation/src/models/app_models/menuitem_model.dart';
 
class ShowMenuItemWidget extends StatelessWidget {
  final MenuItem_Model itemMenu;

  const ShowMenuItemWidget({
    @required this.itemMenu,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 10.0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                    color: this.itemMenu.color,
                    borderRadius: BorderRadius.circular(100.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        this.itemMenu.icon,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(this.itemMenu.title, overflow: TextOverflow.ellipsis, style: TextStyle(color: this.itemMenu.color, fontSize: 18.0),),
                )
              ],

            ),
          ],
        )
      ),
      onPressed: (){
        Navigator.pushNamed(context, this.itemMenu.route);
      },
      color: Colors.white,
      
    );
  }
}