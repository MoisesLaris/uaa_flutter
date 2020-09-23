import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarFeedback {
  

  static void flushbar_feedback(BuildContext context,String title,String message,bool success){
    Flushbar(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 64.0),
      isDismissible: false,
      borderRadius: 10.0,
      blockBackgroundInteraction: false,
      backgroundGradient: LinearGradient(colors: success ? [Colors.green.shade600.withOpacity(0.8), Colors.greenAccent.shade700.withOpacity(0.8) ] : [Colors.red.withOpacity(0.8), Colors.redAccent.withOpacity(0.8)], stops: [0.6,1]),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3,3),
          blurRadius: 3,
        )
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(seconds: 1),
      icon: Icon(
        success ? Icons.check_circle : Icons.cancel,
        size: 40.0,
        color: Colors.white,
      ),
      flushbarPosition: FlushbarPosition.BOTTOM,
      title: title,
      message: message,
    ).show(context);
  }

}
