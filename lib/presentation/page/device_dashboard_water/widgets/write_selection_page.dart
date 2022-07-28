import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/other/status_bar.dart';
import 'card_wigdets.dart';
import 'handwriting_page.dart';
import 'read_exel.dart';

class WriteSelectionPage extends StatefulWidget {
  WriteSelectionPage({Key? key}) : super(key: key);

  @override
  State<WriteSelectionPage> createState() => _WriteSelectionPageState();
}

class _WriteSelectionPageState extends State<WriteSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Theme.of(context).primaryColor,
          iconSize: 20,
        ),
        systemOverlayStyle: statusBar(context),
        title: Text(
          "Ma'lumotlarni yozish",
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 20),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              "Ma'lumotni kiritish usulni tanlang",
              style:
                  GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                cardWidgets(
                  context,
                  "Exel fayl orqali  ma'lumotni kiritish",
                  FontAwesome5.file_excel,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadExel(),
                      ),
                    );
                  },
                ),
                cardWidgets(
                  context,
                  "Qo'lda ma'lumotni kiritish",
                  Icons.create,
                  () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HandWritingPage(),
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
