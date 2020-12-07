import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:form_validation/src/models/app_models/menuitem_model.dart';
import 'package:form_validation/src/pages/menu/itemsMenu.dart';
import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:form_validation/src/widgets/showMenuItem.dart';

class MenuPage extends StatelessWidget {
  final _prefs = PreferenciasUsuario();
  List<MenuItem_Model> arrayMenuItems = [];
  @override
  Widget build(BuildContext context) {
    _listaDeMenus();
    return _crearMenus(context);
  }

  void _listaDeMenus(){
    // if(_prefs.isAdmin == true){
    //   arrayMenuItems = menuItems;
    //   return;
    // }
    menuItems.forEach((menu) {
      if(_prefs.isAdmin == menu.isAdmin){
        arrayMenuItems.add(menu);
      }
    });
  }

  Widget _crearMenus(BuildContext context) {
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: arrayMenuItems.length,
      itemBuilder: (BuildContext context, int index) => ShowMenuItemWidget(itemMenu: arrayMenuItems[index]),
      staggeredTileBuilder: (int index) => StaggeredTile.extent(2, 130.0),
    );
  }
}
