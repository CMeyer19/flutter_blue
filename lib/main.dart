import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bluetooth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Bluetooth Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
  final FlutterBlue flutterBlueInstance = FlutterBlue.instance;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BluetoothDevice device;
  BluetoothState state;
  BluetoothDeviceState deviceState;

  StreamSubscription<ScanResult> scanSubscription;

  @override
  void initState() {
    super.initState();

    //checks bluetooth current state
    FlutterBlue.instance.state.listen((state) {
      if (state == BluetoothState.off) {
        //Alert user to turn on bluetooth.
      } else if (state == BluetoothState.on) {
        //if bluetooth is enabled then go ahead.
        //Make sure user's device gps is on.
        scanForDevices();
      }
    });
  }

  void scanForDevices() async {
    scanSubscription =
        widget.flutterBlueInstance.scan().listen((scanResult) async {
      if (scanResult.device.name == "") {
        return;
      }
      print("Boobs" + scanResult.device.name);

      if (scanResult.device.name == "H705") {
        print("found device");
        //Assigning bluetooth device
        device = scanResult.device;
        //After that we stop the scanning for device
        stopScanning();
      }
    });
  }

  void stopScanning() {
    widget.flutterBlueInstance.stopScan();
    scanSubscription.cancel();
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = new List<Container>();
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
              FlatButton(
                color: Colors.blue,
                child: Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildListViewOfDevices(),
    );
  }
}
