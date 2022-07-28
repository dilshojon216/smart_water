import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget cardMenu(String name, icon, context, onClick) {
  return Card(
    elevation: 5,
    child: TextButton(
      onPressed: onClick,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              child:
                  Icon(icon, color: Theme.of(context).primaryColor, size: 80),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    ),
  );
}
