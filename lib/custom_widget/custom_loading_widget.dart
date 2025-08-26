import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(radius: 12);
  }
}
