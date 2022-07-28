import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarWidgets extends StatelessWidget {

  const AppBarWidgets({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70),
      child: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Theme.of(context).primaryColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_outlined),color: Theme.of(context).primaryColor,)
        ],
      ),
    );
  }
}