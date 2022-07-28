import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

onLoading(context, text) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: SizedBox(
          height: 100,
          width: 200,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 60,
                width: 60,
                padding: const EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                text,
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      );
    },
  );
}
