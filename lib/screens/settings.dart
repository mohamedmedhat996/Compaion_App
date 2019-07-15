import 'package:companion/screens/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:companion/screens/bottom_Nav.dart' as home;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

bool _daef = false; // or true
bool _notification = false;
bool _alarm = false;

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

int reset, deaf, notification, alarm;

Future _showAlert(BuildContext context, String message) async {
  return showDialog(
      context: context,
      child: AlertDialog(
        title: Text(message),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.pop(context), child: Text('yes')),
          FlatButton(
              onPressed: () => Navigator.pop(context), child: Text('no')),
        ],
      ));
}

class SwitchExampleState extends State {
  FlutterBluetoothSerial bluetooth = home.returnBluetooth();
  int deaf = 0;
  int notification = 0;
  int reset = 0;
  int alarm = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Stack(children: [
          Center(
            child: new Image.asset('assets/background.png',
                width: size.width, height: size.height, fit: BoxFit.fill),
          ),
          Align(
            alignment: Alignment(-1, -.95),
            child: SwitchListTile(
              value: _daef,
              title: Text('Deaf Mode',
                  textScaleFactor: 1.3,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              activeColor: Colors.red,
              secondary: _daef ? Icon(Icons.mic_off,size:40,color:Colors.white) : Icon(Icons.mic,size:40,color:Colors.white ),
              onChanged: (bool value) {
                print('$value');
                setState(() {
                  _daef = value;
                });
                _daef ? deaf = 1 : deaf = 0;
                sendDataSettings(deaf, notification, reset, alarm);
              },
            ),
          ),
          Align(
            alignment: Alignment(-0.5, -0.75),
            child: SwitchListTile(
              value: _notification,
              title: Text('Turn off Notification',
                  textScaleFactor: 1.3,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              activeColor: Colors.red,
              secondary: _notification
                  ? Icon(Icons.volume_off,size:40,color:Colors.white,)
                  : Icon(Icons.volume_up,size:40,color:Colors.white),
              onChanged: (bool value) {
                print('$value');
                setState(() {
                  _notification = value;
                });
                _notification ? notification = 1 : notification = 0;
                sendDataSettings(deaf, notification, reset, alarm);
              },
            ),
          ),
          /////////restore///////////////
          Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                  icon: Icon(Icons.restore, color: Colors.red),
                  iconSize: 55,
                  // onPressed:() => _showAlert(context, 'Do you to reset the device '))
                  onPressed: () => showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('Do you want to Reset the Settings'),
                        actions: <Widget>[
                          FlatButton(
                              //onPressed: () => Navigator.pop(context),
                              onPressed: () {
                                Navigator.pop(context);
                                reset = 1;
                                sendDataSettings(deaf, notification, reset, alarm);
                                reset = 0;
                              },
                              child: Text('Yes')),
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                reset = 0;
                                sendDataSettings(deaf, notification, reset, alarm);
                              },
                              child: Text('No')),
                        ],
                      )))),
          Align(
            alignment: Alignment(-0.5, -0.55),
            child: SwitchListTile(
              value: _alarm,
              title: Text('Turn off Alarm',
                  textScaleFactor: 1.3,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              activeColor: Colors.red,
              secondary: _alarm ? Icon(Icons.alarm_off,size:40,color:Colors.white) : Icon(Icons.alarm_on,size:40,color:Colors.white),
              onChanged: (bool value) {
                print('$value');
                setState(() {
                  _alarm = value;
                });
                _alarm ? alarm = 1 : alarm = 0;
                sendDataSettings(deaf, notification, reset, alarm);
              },
            ),
          ),
        ]
      )
    );
  }

  resetFun() {
    reset = 1;
    sendDataSettings(deaf, notification, reset, alarm);
    reset = 0;
  }

void sendDataSettings(int deaf, int notification, int reset, int alarm) {
    // data = '{"Request":"Option", "Deaf Mode": 1, "Notification": 0, "Reset": 1, "Alarm": 0}';
    String data = '{"Request":"Option", "Deaf Mode": "' +
        deaf.toString() +
        '", "Notification": "' +
        notification.toString() +
        '", "Reset": "' +
        reset.toString() +
        '", "Alarm": "' +
        alarm.toString() +
        '"}';
    print(data);
    sendData(data);
  }

  CustomDialog({String title, String description, String buttonText}) {}
}

class SwitchExample extends StatefulWidget {
  @override
  SwitchExampleState createState() => new SwitchExampleState();
}
