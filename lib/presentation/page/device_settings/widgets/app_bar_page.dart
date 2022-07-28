import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/other/status_bar.dart';

class AppBarDeviceSettings extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  const AppBarDeviceSettings({Key? key, required this.title}) : super(key: key);

  @override
  State<AppBarDeviceSettings> createState() => _AppBarDeviceSettingsState();

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}

class _AppBarDeviceSettingsState extends State<AppBarDeviceSettings> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: statusBar(context),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_outlined),
        color: Theme.of(context).primaryColor,
        iconSize: 20,
      ),
      elevation: 2,
      title: Text(
        widget.title,
        style: GoogleFonts.roboto(
            color: Theme.of(context).primaryColor, fontSize: 16),
      ),
      backgroundColor: Colors.white,
    );
  }
}
