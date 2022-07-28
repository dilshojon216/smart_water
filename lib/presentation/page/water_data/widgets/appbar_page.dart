import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/model/organization.dart';

class AppBarWater extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> keys;

  const AppBarWater({Key? key, required this.title, required this.keys})
      : super(key: key);

  @override
  State<AppBarWater> createState() => _AppBarWaterState();

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}

class _AppBarWaterState extends State<AppBarWater> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Theme.of(context).primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      leading: IconButton(
          onPressed: () {
            widget.keys.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            size: 25,
            color: Theme.of(context).primaryColor,
          )),
      elevation: 2,
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.search,
                size: 25, color: Theme.of(context).primaryColor)),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert,
                size: 25, color: Theme.of(context).primaryColor)),
      ],
      title: Center(
        child: Text(
          widget.title,
          style: GoogleFonts.roboto(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
