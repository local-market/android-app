import 'package:flutter/material.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";

class CircularLoadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      minWidth: MediaQuery.of(context).size.width,
      child: SpinKitCircle(color: Colors.white)
    );
  }
}