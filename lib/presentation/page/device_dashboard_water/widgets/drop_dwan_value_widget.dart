import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropDwanValueWidget extends StatelessWidget {
  final String title;
  final List<int?> list;
  final Function(int?) onChanged;
  final int? value;
  final String hint;

  const DropDwanValueWidget({
    Key? key,
    required this.title,
    required this.list,
    required this.onChanged,
    required this.value,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(list.toString() + " " + value.toString());
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 5,
        child: Container(
          height: 50,
          margin: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 9,
                child: AutoSizeText(
                  title,
                  style: GoogleFonts.roboto(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                  flex: 5,
                  child: DropdownButton(
                    hint: Text(
                      hint,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    value: value,
                    onChanged: onChanged,
                    isExpanded: true,
                    underline: Container(),
                    style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w900),
                    dropdownColor: Colors.white,
                    focusColor: Colors.black,
                    iconEnabledColor: Theme.of(context).primaryColor,
                    iconSize: 32,
                    items: list.map(
                      (int? region) {
                        return DropdownMenuItem(
                          value: region,
                          child: Text(
                            region.toString(),
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
