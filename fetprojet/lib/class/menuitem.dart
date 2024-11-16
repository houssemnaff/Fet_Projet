import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final Function(BuildContext)? routerpage; // Optional router function

  MenuItem(this.title, this.icon, [this.routerpage]); // Optional parameter for router
}