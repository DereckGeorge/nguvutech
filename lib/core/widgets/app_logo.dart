import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;

  const AppLogo({Key? key, this.width = 40, this.height = 40})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(6),
      child: Image.asset('assets/logo.png'),
    );
  }
}
