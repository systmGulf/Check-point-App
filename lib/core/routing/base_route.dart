import 'package:flutter/material.dart';

class BaseRoute extends MaterialPageRoute<dynamic> {
  BaseRoute({required Widget page})
      : super(
          builder: (BuildContext context) => page,
        );
}
