import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:smart_water/presentation/page/device_dashboard_water/widgets/on_loading.dart';

import '../../../../translations/locale_keys.g.dart';
import '../../../cubit/sign_in_pump_cubit/signin_pump_cubit.dart';
import '../../../cubit/sign_in_pump_cubit/signin_pump_state.dart';
import '../pump_viewmodel.dart';

class SignInPageAlert extends StatefulWidget {
  SignInPageAlert({Key? key}) : super(key: key);

  @override
  State<SignInPageAlert> createState() => _SignInPageAlertState();
}

class _SignInPageAlertState extends State<SignInPageAlert> {
  String errorMessage = "";
  bool isLoading = false;
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void singIn() async {
    if (_loginController.value.text != "" &&
        _passwordController.value.text != "") {
      bool internetConnection = await InternetConnectionChecker().hasConnection;
      if (internetConnection) {
        BlocProvider.of<SignInPumpCubit>(context).signIn(
            _loginController.value.text, _passwordController.value.text);
      } else {
        setState(() {
          errorMessage = "No internet connection";
        });
      }
    } else {
      setState(() {
        errorMessage = "Ma'lumotlarni kiriting";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInPumpCubit, SignInPumpState>(
      listener: (context, state) {
        if (state is SignInPumpLoading) {
          onLoading(context, "Signing in...");
        } else if (state is GetUserToken) {
          Navigator.of(context).pop();
          print("token: ${state.token}");
          //  Navigator.of(context).pop();

          context.read<SignInPumpCubit>().getServerStations(state.token);
        } else if (state is GetStations) {
          Navigator.of(context).pop();
          context.read<SignInPumpCubit>().setLocalBaseData(state.data);
        } else if (state is SaveLocalBaseStations) {
          Navigator.of(context).pop(true);
        } else if (state is SignInPumpEroror) {
          Navigator.of(context).pop();
          setState(() {
            errorMessage = state.error;
          });
        }
      },
      child: SizedBox(
        height: 250,
        width: 300,
        child: SingleChildScrollView(
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
                          singIn();
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
}
