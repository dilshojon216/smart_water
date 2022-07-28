import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/presentation/routes/app_routes.dart';

import 'widgets/app_bar_page.dart';

class UserAbout extends StatefulWidget {
  final String title;
  const UserAbout({Key? key, required this.title}) : super(key: key);

  @override
  State<UserAbout> createState() => _UserAboutState();
}

class _UserAboutState extends State<UserAbout> {
  int valueWater = 1;
  int valueWell = 2;

  @override
  void initState() {
    super.initState();
    getDataType();
  }

  void getDataType() async {
    var _prefs = await SharedPreferences.getInstance();
    setState(() {
      valueWater = _prefs.getInt('valueWater') ?? 1;
      valueWell = _prefs.getInt('valueWell') ?? 2;
    });
  }

  setDataType(String type, int value) async {
    var _prefs = await SharedPreferences.getInstance();
    if (type == 'water') {
      _prefs.setInt('valueWater', value);
      _prefs.setString("token", "");

      _prefs.setString("userToken", "");

      _prefs.setString("waterInstall", "");
      _prefs.setString("stations", "");
    } else {
      _prefs.setInt('valueWell', value);
      _prefs.setString("wellInstall", "false");
    }

    closeApp();
  }

  closeApp() {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutesNames.splashPage, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBarUserAbout(title: widget.title),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                "Ma'lumotlarni o'qish turi",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              child: Container(
                height: 120,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Smart Water",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                value: 1,
                                groupValue: valueWater,
                                onChanged: (int? value) {
                                  setState(() {
                                    valueWater = value!;
                                    setDataType('water', value);
                                  });
                                },
                              ),
                              Text(
                                "HTTP",
                                style: GoogleFonts.roboto(
                                    fontSize: 20, fontWeight: FontWeight.w900),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                value: 2,
                                groupValue: valueWater,
                                onChanged: (int? value) {
                                  setState(() {
                                    valueWater = value!;
                                    setDataType('water', value);
                                  });
                                },
                              ),
                              Text(
                                "MQTT",
                                style: GoogleFonts.roboto(
                                    fontSize: 20, fontWeight: FontWeight.w900),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              child: Container(
                height: 120,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Smart Well",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                value: 1,
                                groupValue: valueWell,
                                onChanged: (int? value) {
                                  setState(() {
                                    valueWell = value!;
                                    setDataType('well', value);
                                  });
                                },
                              ),
                              Text(
                                "HTTP",
                                style: GoogleFonts.roboto(
                                    fontSize: 20, fontWeight: FontWeight.w900),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                value: 2,
                                groupValue: valueWell,
                                onChanged: (int? value) {
                                  setState(() {
                                    valueWell = value!;
                                    setDataType('well', value);
                                  });
                                },
                              ),
                              Text(
                                "MQTT",
                                style: GoogleFonts.roboto(
                                    fontSize: 20, fontWeight: FontWeight.w900),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
