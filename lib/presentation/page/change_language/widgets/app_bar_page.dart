import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarChangeLanguage extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  const AppBarChangeLanguage({Key? key, required this.title}) : super(key: key);

  @override
  State<AppBarChangeLanguage> createState() => _AppBarChangeLanguageState();

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}

class _AppBarChangeLanguageState extends State<AppBarChangeLanguage> {
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
