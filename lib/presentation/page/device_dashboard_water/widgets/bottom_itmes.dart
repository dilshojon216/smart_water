import 'package:flutter/material.dart';

BottomNavigationBarItem bottomItems(context, text, icons) {
  return BottomNavigationBarItem(
    icon: Icon(
      icons,
      color: Theme.of(context).primaryColor,
    ),
    label: text,
  );
}
