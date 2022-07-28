import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget headerDrawer(String name, String phone, context) {
  return Container(
    margin: const EdgeInsets.only(top: 40, left: 10, right: 50),
    height: 100,
    width: MediaQuery.of(context).size.width,
    child: Row(
      children: [
        const Expanded(
          flex: 1,
          child: Image(
            image: AssetImage("assets/images/applogo.png"),
            width: 50,
            height: 80,
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 16),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(phone,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 14)),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
