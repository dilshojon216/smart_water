import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_water/presentation/page/device_dashboard_well/device_dashboard_well.dart';
import 'package:smart_water/presentation/routes/app_routes.dart';

import '../../device_dashboard_water/device_dashboard_water.dart';
import 'bluetooth_device_list_entry.dart';

class WaterDeviceConntion extends StatefulWidget {
  final String title;
  WaterDeviceConntion({Key? key, required this.title}) : super(key: key);

  @override
  State<WaterDeviceConntion> createState() => _WaterDeviceConntionState();
}

enum _DeviceAvailability {
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int? rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class _WaterDeviceConntionState extends State<WaterDeviceConntion> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  List<_DeviceWithAvailability> devices =
      List<_DeviceWithAvailability>.empty(growable: true);
  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;
  bool isDisconnecting = false;
  String typeString = "";
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;

  bool _isButtonUnavailable = false;
  @override
  void initState() {
    premistion();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    typeString = ModalRoute.of(context)!.settings.arguments as String;
  }

  void premistion() async {
    bool bluetoothConnection = await Permission.bluetoothConnect.isGranted;
    bool bluetoothScan = await Permission.bluetoothScan.isGranted;
    print(bluetoothConnection.toString() + bluetoothScan.toString());
    if (!bluetoothConnection || !bluetoothScan) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();

      if (statuses[Permission.bluetoothScan]!.isGranted &&
          statuses[Permission.bluetoothConnect]!.isGranted) {
        initBluetooth();
      }
    } else {
      initBluetooth();
    }
  }

  void initBluetooth() async {
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    enableBluetooth();

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  Future<bool> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    _startDiscovery();

    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map(
              (device) =>
                  _DeviceWithAvailability(device, _DeviceAvailability.yes),
            )
            .toList();
      });
    });
  }

  void _startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        Iterator i = devices.iterator;
        while (i.moveNext()) {
          var _device = i.current;
          if (_device.device == r.device) {
            _device.availability = _DeviceAvailability.yes;
            _device.rssi = r.rssi;
          }
        }
      });
    });

    _discoveryStreamSubscription?.onDone(() {
      setState(() {
        //  _isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    _discoveryStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDeviceListEntry> list = devices
        .map((_device) => BluetoothDeviceListEntry(
              device: _device.device,
              rssi: _device.rssi,
              enabled: _device.availability == _DeviceAvailability.yes,
              onTap: () {
                if (typeString == "water") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeviceDashboradWater(
                        device: _device.device,
                      ),
                    ),
                  );
                } else if (typeString == "well") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeviceDashboradWell(
                        device: _device.device,
                      ),
                    ),
                  );
                }
              },
            ))
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Theme.of(context).primaryColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_outlined),
            color: Theme.of(context).primaryColor,
            iconSize: 20),
        elevation: 2,
        title: Text(
          widget.title,
          style: GoogleFonts.roboto(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_bluetoothState == BluetoothState.STATE_OFF) {
                enableBluetooth();
              }
            },
            icon: _bluetoothState == BluetoothState.STATE_OFF
                ? const Icon(Icons.bluetooth_disabled)
                : const Icon(Icons.bluetooth),
            color: Theme.of(context).primaryColor,
            iconSize: 25,
          ),
          IconButton(
            onPressed: () {
              FlutterBluetoothSerial.instance.openSettings();
            },
            icon: const Icon(Icons.settings_bluetooth),
            color: Theme.of(context).primaryColor,
            iconSize: 25,
          ),
          IconButton(
            onPressed: () {
              if (_bluetoothState == BluetoothState.STATE_ON) {
                getPairedDevices();
              }
            },
            icon: const Icon(Icons.refresh),
            color: Theme.of(context).primaryColor,
            iconSize: 25,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: ListView(children: list),
    );
  }
}
