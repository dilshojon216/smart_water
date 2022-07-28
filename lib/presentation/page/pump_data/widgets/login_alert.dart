import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/model/mqtt_user_token.dart';
import '../../../../data/model/water_user_token.dart';
import '../../../cubit/sign_in_water_cubit/sign_in_water_cubit.dart';
import '../../../cubit/sign_in_water_cubit/sign_in_water_state.dart';
import '../../../cubit/signin_well_cubit/sign_in_well_cubit.dart';
import '../../../cubit/signin_well_cubit/sign_in_well_state.dart';

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

  saveData(MqttUserToken token) async {
    try {
      var _prefs = await SharedPreferences.getInstance();

      String wellIMEi = token.well;
      List<String> wellIMEiList = [];
      if (wellIMEi.contains(",")) {
        wellIMEiList = wellIMEi.split(",");
      } else {
        wellIMEiList.add(wellIMEi);
      }

      _prefs.setStringList("wellIMEiList", wellIMEiList);

      _prefs.setString("wellInstall", "true");
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInWellCubit, SignInWellState>(
      listener: (context, state) {
        if (state is SignInWellMqttLoadedState) {
          isLoading = false;
          saveData(state.token);
        } else if (state is SignInWellErrorState) {
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
                  labelText: 'Login',
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
                  labelText: 'Parol',
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
                            errorMessage = "Login va parolni kiriting";
                          });
                        }
                      },
                      child: Text(
                        "Kirish",
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
    bool internetConnection = await InternetConnectionChecker().hasConnection;
    if (internetConnection) {
      setState(() {
        isLoading = true;
      });
      BlocProvider.of<SignInWellCubit>(context)
          .signIn(_loginController.value.text, _passwordController.value.text);
    } else {
      setState(() {
        errorMessage = "Internet bilan bog'lanishda xatolik yuz berdi";
      });
    }
  }
}
