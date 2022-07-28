import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWaterFlowCalc extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  const AppBarWaterFlowCalc({Key? key, required this.title}) : super(key: key);

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
  @override
  State<AppBarWaterFlowCalc> createState() => _AppBarWaterFlowCalcState();
}

class _AppBarWaterFlowCalcState extends State<AppBarWaterFlowCalc> {
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
