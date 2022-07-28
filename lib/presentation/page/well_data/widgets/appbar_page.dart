import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWell extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  const AppBarWell({Key? key, required this.title}) : super(key: key);

  @override
  State<AppBarWell> createState() => _AppBarWellState();

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}

class _AppBarWellState extends State<AppBarWell> {
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
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Theme.of(context).primaryColor,
          iconSize: 25),
      elevation: 2,
      actions: [
        IconButton(
            onPressed: () {
              print("sdsd");
            },
            icon: SvgPicture.asset(
              "assets/icons/search.svg",
              color: Theme.of(context).primaryColor,
              height: 25,
              width: 25,
            )),
        IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/filter.svg",
              color: Theme.of(context).primaryColor,
              height: 25,
              width: 25,
            )),
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
