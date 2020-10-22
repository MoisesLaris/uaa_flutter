import 'package:flutter/material.dart';
import 'package:form_validation/src/models/app_models/menuitem_model.dart';
import 'package:form_validation/theme/theme.dart';
import 'package:provider/provider.dart';
 
class ShowMenuItemWidget extends StatelessWidget {
  final MenuItem_Model itemMenu;

  const ShowMenuItemWidget({
    @required this.itemMenu,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeChanger>(context).darkTheme;
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 10.0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Column(
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
            ),
          ],
        )
      ),
      onPressed: (){
        if(this.itemMenu.arguments != null){
          Navigator.pushNamed(context, this.itemMenu.route, arguments: this.itemMenu.arguments);
        }else{
          Navigator.pushNamed(context, this.itemMenu.route);
        }
      },
      color: isDark ? Colors.grey[800] : Colors.white,
      
    );
  }
}