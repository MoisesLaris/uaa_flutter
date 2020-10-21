import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:form_validation/src/pages/faq/itemsFAQ.dart';
import 'package:form_validation/src/widgets/showMenuItem.dart';

class FaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Container(
        //   alignment: Alignment.topLeft,
        //       padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        //       child: Text('Preguntas', style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold,),),
        // ),
        Expanded(child: _crearMenusPreguntas(context))
      ],
      
    );
  }

  Widget _crearMenusPreguntas(BuildContext context){
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: faqItems.length,
      itemBuilder: (BuildContext context, int index) => ShowMenuItemWidget(
        itemMenu: faqItems[index],
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.extent(2, 130.0),
    );
  }
}