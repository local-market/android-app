import 'package:flutter/material.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";
import 'package:local_market/utils/utils.dart';

class CircularLoadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: Utils().elevation,
      onPressed: () {},
      minWidth: MediaQuery.of(context).size.width,
      child: SpinKitCircle(color: Utils().colors['loadingInverse'])
    );
  }
}