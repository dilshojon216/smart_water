import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water/data/model/sensor_type.dart';

class SensorTypeValueWidget extends StatelessWidget {
  final String title;
  final List<SensorType?> list;
  final Function(SensorType?) onChanged;
  final SensorType? value;

  const SensorTypeValueWidget(
      {Key? key,
      required this.title,
      required this.list,
      required this.onChanged,
      this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                flex: 4,
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
                    "Sensor turini tanlang",
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
                    (SensorType? region) {
                      return DropdownMenuItem(
                        value: region,
                        child: Text(
                          region!.name,
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
