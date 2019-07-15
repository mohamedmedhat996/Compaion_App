// For performing some operations asynchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:companion/screens/bluetooth_controller.dart';
import 'package:companion/screens/bottom_Nav.dart' as home;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

bool _connected = false;
void setConnected(bool connect) {
  _connected = connect;
}

bool _pressed = false;
void setPressed(bool pressed) {
  _pressed = pressed;
}

BluetoothDevice _device;

class _BluetoothAppState extends State<BluetoothApp> {
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FlutterBluetoothSerial bluetooth = home.returnBluetooth();
  List<BluetoothDevice> _devicesList = home.returnBluetoothDeviceList();

  // Now, its time to build the UI
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Bluetooth"),
        backgroundColor: Color.fromRGBO(10, 10, 10, 1.0),
      ),
      body:Stack(
        children: <Widget>[
          Center(
            child: Image.asset('assets/background.png',
            width: size.width, height: size.height, fit: BoxFit.fill)
          ),
          Padding(
              padding: const EdgeInsets.only(top:200.0,left:20 ),
              child: Text(
                "Paired Devices",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22,color:Colors.white),
                //textAlign: TextAlign.center,
                
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:180.0,left: 190),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                  ),
                  DropdownButton(
                    items: _getDeviceItems(),
                    onChanged: (value) => setState(() => _device = value),
                    value: _device,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:250.0,left:112),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.black,
                      onPressed:
                          _pressed ? null : _connected ? _disconnect : _connect,
                      child: Text(
                        _connected ? 'Disconnect' : 'Connect',
                        style: TextStyle(fontSize: 25,color:Colors.white), 
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                ],
              ),
            ),
           /* Expanded(
              child: Padding(
               padding: const EdgeInsets.only(bottom: 10) ,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Connecting to Companion Using Bluetooth:\n 1-Open your device's Settings.\n 2-Tap Connected devices and then\n   Connection preferences\n   and then Bluetooth. 'If you don't see\n   Connection preferences, go to Step 3'\n 3-Turn Bluetooth on.\n 4-Choose your Companion device\n   from the list above then press connect",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ]),
              ),
            )*/
          ],
        
      
        //////////////
      ),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        
        child:Padding(
          padding: const EdgeInsets.only(top:50.0,left:10 ),
          child:Text('None'),
        ),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() async {
    var _connected = false;
    if (_device == null) {
      show('No device selected');
    } else {
      await bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth
              .connect(_device)
              .timeout(Duration(seconds: 500))
              .catchError((error) {
            setState(() => _pressed = false);
          });
          setState(() => _pressed = true);
          _connected = true;
        }
        if (_connected == true && _pressed == true) {
          show('Connection Done');
        } else {
          show('Error in Connection');
        }
      });
      home.setBluetooth(bluetooth);
    }
    receiveStreaming();
  }

  // Method to disconnect bluetooth
  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _pressed = true);
    show('Connection End');
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
