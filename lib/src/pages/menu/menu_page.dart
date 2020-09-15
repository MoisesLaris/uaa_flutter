import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:form_validation/src/pages/menu/itemsMenu.dart';
import 'package:form_validation/src/widgets/flushbar_feedback.dart';
import 'package:form_validation/src/widgets/showMenuItem.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _crearMenus(context);
  }

  Widget _crearMenus(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: menuItems.length,
      itemBuilder: (BuildContext context, int index) => ShowMenuItemWidget(
        itemMenu: menuItems[index],
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.extent(1, 130.0),
    );
  }
}
