import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppSystemUiScope extends StatelessWidget {
  const AppSystemUiScope({
    super.key,
    required this.style,
    required this.child,
  });

  final SystemUiOverlayStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: child,
    );
  }
}
