

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water/presentation/page/signin_page/widgets/logo_widgets.dart';

import 'widgets/app_bar_widgets.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
       leading:  Container(

         decoration: BoxDecoration(
           shape: BoxShape.circle,
           border: Border.all(
             color: Theme.of(context).primaryColor,
           ),
         ),
           margin: const EdgeInsets.only(top: 10,left: 10),
           child: IconButton(onPressed: (){
             Navigator.pop(context);
           }, icon: Icon(Icons.arrow_back_outlined),color: Theme.of(context).primaryColor,)),
      ),
      body: Column(
        children: [
          logoWidgets(size)

        ],
      ),
    );
  }
}
