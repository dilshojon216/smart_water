import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:smart_water/core/other/status_bar.dart';
import 'package:smart_water/presentation/page/bluetooth_terminal/bluetooth_terminal.dart';
import 'package:smart_water/presentation/page/device_dashboard_water/widgets/home_screen.dart';
import 'package:smart_water/presentation/page/device_dashboard_water/widgets/table_screen.dart';

import '../../routes/app_routes.dart';
import '../device_dashboard_water/widgets/card_menu.dart';
import '../device_dashboard_water/widgets/on_loading.dart';
import '../device_dashboard_water/widgets/settings_screen.dart';
import 'widgets/home_srceen_well.dart';

class DeviceDashboradWell extends StatefulWidget {
  final BluetoothDevice device;
  DeviceDashboradWell({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceDashboradWell> createState() => _DeviceDashboradWellState();
}

class _DeviceDashboradWellState extends State<DeviceDashboradWell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  StreamSubscription<Uint8List>? _subscription;
  BluetoothConnection? connection;
  int? _deviceState;
  bool isDisconnecting = false;
  bool get isConnected => connection != null && connection!.isConnected;
  final List<BluetoothDevice> _devicesList = [];

  bool _connected = false;
  bool _isButtonUnavailable = false;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("ssss");
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null;
    }
    super.dispose();
  }

  void initBluetooth() {
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    _deviceState = 0;
    enableBluetooth();

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
      });
    });
  }

  Future<bool> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    print("sdsd");
    inintelData();
  }

  inintelData() {
    initBluetooth();
    _connect();
  }

  int selectedIndex = 0;
  bool ass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        key: _scaffoldKey,
        appBar: AppBar(
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
          actions: [
            IconButton(
              onPressed: () {
                if (_connected) {
                  _disconnect();
                } else {
                  _connect();
                }
              },
              icon: _connected
                  ? const Icon(Icons.bluetooth_connected)
                  : const Icon(Icons.bluetooth_disabled),
              color: Theme.of(context).primaryColor,
              iconSize: 25,
            ),
          ],
          title: Text(
            "${widget.device.name}",
            style: GoogleFonts.roboto(
                color: Theme.of(context).primaryColor, fontSize: 16),
          ),
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                "Kerakli menuni tanlang",
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  cardMenu("Bosh Oyna", Icons.home, context, () {
                    if (_connected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreenWell(
                            title: "Bosh oyna",
                            connection: connection,
                            subscription: _subscription,
                          ),
                        ),
                      );
                    } else {
                      show("Qurilma bilan bog'lanmagan");
                    }
                  }),
                  cardMenu("Sozlamalar", Icons.settings, context, () {
                    if (_connected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                            title: "Sozlamalar",
                            connection: connection,
                            subscription: _subscription,
                          ),
                        ),
                      );
                    } else {
                      show("Qurilma bilan bog'lanmagan");
                    }
                  }),
                  cardMenu("Terminal", Icons.terminal, context, () {
                    if (_connected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BluetoothTerminal(
                            title: "Terminal",
                            connection: connection,
                            subscription: _subscription,
                          ),
                        ),
                      );
                    } else {
                      show("Qurilma bilan bog'lanmagan");
                    }
                  }),
                ],
              ),
            ),
          ],
        ));
  }

  int a = 0;
  void _connect() async {
    Future.delayed(
        Duration.zero, () => onLoading(context, "Connecting to device ..."));
    setState(() {
      _isButtonUnavailable = true;
    });
    if (widget.device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        try {
          await BluetoothConnection.toAddress(
            widget.device.address,
          ).timeout(const Duration(seconds: 60), onTimeout: () {
            return Future.error('timed out');
          }).then((_connection) {
            print('Connected to the device');

            connection = _connection;

            _subscription = connection!.input!.listen((data) {
              print('Received data: ' + data.toString());
            });

            setState(() {
              _connected = true;
            });
          }).catchError((error) {
            print('Cannot connect, exception occurred');
            print(error);
          });

          Navigator.of(context).pop();
          if (connection == null) {
            showMessage(
                "Qurilma bilan bog'lanib bo'lmadi.\nIltimos, qayta urinib ko'ring!");
          } else {
            if (connection!.isConnected) {
              show("Qurilma bilan bog'landi.");
            }
          }

          setState(() => _isButtonUnavailable = false);
        } on PlatformException catch (err) {
          print("sss" + err.toString());
        } catch (e) {
          print(e.toString());
        }
      }
    }
  }

  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection!.close();
    show('Device disconnected');
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        print(_connected);
        _isButtonUnavailable = false;
      });
    }
  }

  void showMessage(String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xabar'),
          content: Text(message),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
