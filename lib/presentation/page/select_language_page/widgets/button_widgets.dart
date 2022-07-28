import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';

class ButtonWidgets extends StatelessWidget {
  final  Size size;
  final String text;
  final onTap;
  const ButtonWidgets({Key? key, required this.size, required this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextButton(
      style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          minimumSize: Size(size.width*0.8, 60)
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: GoogleFonts.roboto(color: AppColors.white,fontSize: 16,fontWeight: FontWeight.w700),
      ),
    );
  }
}
