import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_water/presentation/page/well_data/pump_viewmodel.dart';

import '../../../translations/locale_keys.g.dart';
import '../../cubit/sign_in_pump_cubit/signin_pump_cubit.dart';
import '../signin_page/signin_page.dart';
import 'widgets/appbar_page.dart';
import 'widgets/last_data_pump.dart';
import 'widgets/sign_in_page.dart';

class WellMainData extends StatefulWidget {
  final String title;
  const WellMainData({Key? key, required this.title}) : super(key: key);

  @override
  State<WellMainData> createState() => _WellMainDataState();
}

class _WellMainDataState extends State<WellMainData> {
  bool? waterInstall;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _waterInstall = context.watch<PumpViewModel>().installBool;
    context.read<PumpViewModel>().getPumpStations1();

    return Scaffold(
      key: _key,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBarWell(
        title: widget.title,
        key1: _key,
      ),
      body: _waterInstall
          ? LastDataPump()
          : Center(
              child: SizedBox(
                height: 200,
                width: 400,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.pump_text_1.tr(),
                        style: GoogleFonts.roboto(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () {
                          showLogin();
                        },
                        child: Text(
                          LocaleKeys.water_data_text_5.tr(),
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  showLogin() async {
    var data = await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.water_data_text_5.tr(),
                    style: GoogleFonts.roboto(
                        fontSize: 20.0,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      icon: Icon(Icons.close,
                          color: Theme.of(context).primaryColor)),
                ],
              ),
              content: BlocProvider(
                create: (context) => SignInPumpCubit(),
                child: SignInPageAlert(),
              ),
            );
          },
        );
      },
    );
    if (data is bool) {
      context.read<PumpViewModel>().setInstall(true);
      context.read<PumpViewModel>().getPumpStations1();
    }
  }
}
