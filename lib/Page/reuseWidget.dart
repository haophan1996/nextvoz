import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PreferredSize preferredSize(String text, double size) {
  return PreferredSize(
    preferredSize: Size.fromHeight(size),
    child: AppBar(
      title: Text(text),
    ),
  );
}
