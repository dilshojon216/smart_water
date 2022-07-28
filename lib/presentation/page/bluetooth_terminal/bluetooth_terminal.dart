import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/other/status_bar.dart';
import 'widgets/terminal_button.dart';

class BluetoothTerminal extends StatefulWidget {
  final String title;
  final BluetoothConnection? connection;
  final StreamSubscription<Uint8List>? subscription;
  BluetoothTerminal(
      {Key? key, required this.title, this.connection, this.subscription})
      : super(key: key);

  @override
  State<BluetoothTerminal> createState() => _BluetoothTerminalState();
}

class _BluetoothTerminalState extends State<BluetoothTerminal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController? _scrollController;
  int? _deviceState;
  bool isDisconnecting = false;
  bool get isConnected =>
      widget.connection != null && widget.connection!.isConnected;
  bool _connected = false;
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final List<BluetoothData> _data = [];

  @override
  void dispose() {
    _scrollController!.dispose();
    widget.subscription!.pause();
    super.dispose();
  }

  void startBluetooth() {
    widget.subscription!.resume();
    _connected = widget.connection!.isConnected;
    if (_connected) {
      _connect();
    }
  }

  @override
  void initState() {
    startBluetooth();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
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
          widget.title,
          style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColor, fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: _connected
                ? const Icon(Icons.bluetooth_connected)
                : const Icon(Icons.bluetooth_disabled),
            color: Theme.of(context).primaryColor,
            iconSize: 25,
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  _data.clear();
                  _controller.text = "";
                });
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).primaryColor,
              iconSize: 25),
        ],
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = _data[index];
                        return Padding(
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: AutoSizeText(
                                  "${item.dateTime.hour}:${item.dateTime.minute}:${item.dateTime.second}.${item.dateTime.microsecond} :",
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: AutoSizeText(
                                  item.message,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.roboto(
                                    color: item.color,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      buttonTerminal(context, "HOME", () {
                        _sendOnMessageToBluetooth("HOME#");
                      }),
                      buttonTerminal(context, "INFO", () {
                        _sendOnMessageToBluetooth("INFO=1#");
                      }),
                      buttonTerminal(context, "DATA", () {
                        _sendOnMessageToBluetooth("DATA#");
                      }),
                      buttonTerminal(context, "SETH", () {
                        setState(() {
                          _controller.text = "SETH=";
                        });
                      }),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 40,
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.0,
                                  ),
                                ),
                                hintText: "Type a message",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            String message = _controller.text;
                            if (message.isNotEmpty) {
                              _sendOnMessageToBluetooth(message);
                            }
                          },
                          icon: const Icon(Icons.send),
                          color: Theme.of(context).primaryColor,
                          iconSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void scrollToBottom() {
    final bottomOffset = _scrollController!.position.maxScrollExtent;
    _scrollController!.animateTo(
      bottomOffset,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  void _scrollDown() {
    _scrollController!.jumpTo(_scrollController!.position.maxScrollExtent);
  }

  void _connect() async {
    if (_connected) {
      try {
        widget.subscription!.onData((data) {
          setState(() {
            if (utf8.decode(data) != "") {
              //  String message = utf8.decode(data).replaceAll("\r\n", "");

              var messageList = utf8.decode(data).split("\r\n");

              for (var message in messageList) {
                if (message != "") {
                  _data.add(BluetoothData(
                    color: Theme.of(context).primaryColor,
                    message: message,
                    dateTime: DateTime.now(),
                  ));
                }
              }
              print(messageList);
              _scrollDown();

              _messages.addAll(messageList);
            }
          });
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void _sendOnMessageToBluetooth(text) async {
    List<int> list = text.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    widget.connection!.output.add(bytes);
    await widget.connection!.output.allSent;

    setState(() {
      _data.add(BluetoothData(
        message: text,
        color: Colors.green,
        dateTime: DateTime.now(),
      ));
      _deviceState = 1; // device on

      _scrollDown();
    });
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}

class BluetoothData {
  final String message;
  final Color color;
  final DateTime dateTime;
  BluetoothData({
    required this.dateTime,
    required this.message,
    required this.color,
  });
}
