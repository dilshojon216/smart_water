import 'package:easy_localization/easy_localization.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/app_bar_page.dart';

class ChangeLanguage extends StatefulWidget {
  final String title;
  const ChangeLanguage({Key? key, required this.title}) : super(key: key);

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  int groupValue = 0;
  SharedPreferences? prefs;
  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  getLanguage() async {
    prefs = await SharedPreferences.getInstance();
    int? a = prefs!.getInt(
      "LANG",
    );
    setState(() {
      if (a == null) {
        groupValue = 1;
      } else {
        groupValue = a;
      }
    });
  }

  setLanguage(String text) {
    switch (text) {
      case "uzb":
        context.setLocale(const Locale("en"));
        groupValue = 1;
        prefs!.setInt("LANG", 1);
        break;
      case "ru":
        context.setLocale(const Locale("ru"));
        groupValue = 2;
        prefs!.setInt("LANG", 2);
        break;
      case "cyril":
        context.setLocale(const Locale("uz"));
        groupValue = 3;
        prefs!.setInt("LANG", 3);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBarChangeLanguage(title: widget.title),
      body: Column(
        children: [
          Card(
            child: TextButton(
              onPressed: () {
                setLanguage("uzb");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flag.fromCode(
                    FlagsCode.UZ,
                    height: 40,
                    width: 80,
                  ),
                  Text(
                    "O'zbecha (Lotin)",
                    style: GoogleFonts.roboto(fontSize: 20),
                  ),
                  Radio(
                      value: 1,
                      groupValue: groupValue,
                      onChanged: (int? value) {
                        setLanguage("uzb");
                      }),
                ],
              ),
            ),
          ),
          Card(
            child: TextButton(
              onPressed: () {
                setLanguage("ru");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flag.fromCode(
                    FlagsCode.RU,
                    height: 40,
                    width: 80,
                  ),
                  Text(
                    "Pусский",
                    style: GoogleFonts.roboto(fontSize: 20),
                  ),
                  Radio(
                      value: 2,
                      groupValue: groupValue,
                      onChanged: (value) {
                        setLanguage("ru");
                      }),
                ],
              ),
            ),
          ),
          Card(
            child: TextButton(
              onPressed: () {
                setLanguage("cyril");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flag.fromCode(
                    FlagsCode.UZ,
                    height: 40,
                    width: 80,
                  ),
                  Text(
                    "Ўзбекча (Кирил)",
                    style: GoogleFonts.roboto(fontSize: 20),
                  ),
                  Radio(
                      value: 3,
                      groupValue: groupValue,
                      onChanged: (value) {
                        setLanguage("cyril");
                      }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
