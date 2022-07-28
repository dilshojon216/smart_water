import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_water/translations/locale_keys.g.dart';

import '../../../../data/model/mqtt_user_token.dart';
import '../../../../data/model/water_user_token.dart';
import '../../../cubit/sign_in_water_cubit/sign_in_water_cubit.dart';
import '../../../cubit/sign_in_water_cubit/sign_in_water_state.dart';

class LoginAlert extends StatefulWidget {
  LoginAlert({Key? key}) : super(key: key);

  @override
  State<LoginAlert> createState() => _LoginAlertState();
}

class _LoginAlertState extends State<LoginAlert> {
  String errorMessage = "";
  bool isLoading = false;
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  saveData(WaterUserToken token) async {
    var _prefs = await SharedPreferences.getInstance();

    String userToken = json.encode(token);
    _prefs.setString("token", token.token);
    _prefs.setString("userToken", userToken);

    _prefs.setString("waterInstall", "true");

    Navigator.of(context).pop(true);
  }

  saveData2(MqttUserToken token) async {
    var _prefs = await SharedPreferences.getInstance();

    try {
      var _prefs = await SharedPreferences.getInstance();

      String wellIMEi = token.water;
      List<String> waterIMEIList = [];
      if (wellIMEi.contains(",")) {
        waterIMEIList = wellIMEi.split(",");
      } else {
        waterIMEIList.add(wellIMEi);
      }

      _prefs.setStringList("waterIMEIList", waterIMEIList);

      _prefs.setString("waterInstall", "true");
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInWaterCubit, SignInWaterState>(
      listener: (context, state) {
        if (state is SignInWaterLoadedState) {
          isLoading = false;
          saveData(state.token);
        } else if (state is SignInWaterMqttState) {
          isLoading = false;
          saveData2(state.user);
        } else if (state is SignInWaterErrorState) {
          setState(() {
            isLoading = false;
            errorMessage = state.error;
          });
        }
      },
      child: SingleChildScrollView(
        child: Container(
          height: 250,
          width: 300,
          child: Column(
            children: [
              TextField(
                controller: _loginController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.account_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  labelText: LocaleKeys.login_alert_1.tr(),
                  iconColor: Theme.of(context).primaryColor,
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock,
                    color: Theme.of(context).primaryColor,
                  ),
                  labelText: LocaleKeys.login_alert_2.tr(),
                  iconColor: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(errorMessage,
                  style: GoogleFonts.roboto(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    )
                  : TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: Size(200, 50),
                      ),
                      onPressed: () {
                        if (_loginController.value.text.isNotEmpty &&
                            _passwordController.value.text.isNotEmpty) {
                          signIn();
                        } else {
                          setState(() {
                            errorMessage = LocaleKeys.login_alert_3.tr();
                          });
                        }
                      },
                      child: Text(
                        LocaleKeys.login_alert_4.tr(),
                        style: GoogleFonts.roboto(
                            color: Colors.white, fontSize: 18),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  signIn() async {
    var _prefs = await SharedPreferences.getInstance();
    int? a = _prefs.getInt("valueWater");
    if (a == 2) {
      bool internetConnection = await InternetConnectionChecker().hasConnection;
      if (internetConnection) {
        setState(() {
          isLoading = true;
        });
        BlocProvider.of<SignInWaterCubit>(context).signInMqtt(
            _loginController.value.text, _passwordController.value.text);
      } else {
        setState(() {
          errorMessage = LocaleKeys.login_alert_5.tr();
        });
      }
    } else {
      bool internetConnection = await InternetConnectionChecker().hasConnection;
      if (internetConnection) {
        setState(() {
          isLoading = true;
        });
        BlocProvider.of<SignInWaterCubit>(context).signIn(
            _loginController.value.text, _passwordController.value.text);
      } else {
        setState(() {
          errorMessage = LocaleKeys.login_alert_5.tr();
        });
      }
    }
  }
}
