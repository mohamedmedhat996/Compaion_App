import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:companion/screens/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:companion/screens/note_list.dart';
import 'bluetooth.dart' as blue;
import 'settings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'dart:async' show Future;
import 'package:companion/screens/profilePage.dart';

class PassDataToPagesBottomNav extends StatefulWidget {
  PassDataToPagesBottomNavState createState() {
    return new PassDataToPagesBottomNavState();
  }
}

// Get the instance of the bluetooth
FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
FlutterBluetoothSerial returnBluetooth() {
  return bluetooth;
}

void setBluetooth(FlutterBluetoothSerial blue) {
  bluetooth = blue;
}

// Define some variables, which will be required later
List<BluetoothDevice> _devicesList = [];
List<BluetoothDevice> returnBluetoothDeviceList() {
  return _devicesList;
}

Key key = new UniqueKey();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

LocationData currentLocation;
StreamSubscription<LocationData> _locationSubscription;

Location _locationService = new Location();
bool _permission = false;
String error;

 var jsonPredictData = null;
 var jsonSuggestData = null;
      
updatePredictData(var data){
  if(data != null){
    jsonPredictData = data;
  }
}
      
updateSuggestData(var data){
  if(data != null){
    jsonSuggestData = data; 
  }
}

class PassDataToPagesBottomNavState extends State<PassDataToPagesBottomNav> {
  int _currIndex = 0;
 
  @override
  void initState() {
    super.initState();
    bluetoothConnectionState();
    initPlatformState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('app_icon');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  // Open App again
  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  Future onSelectNotification(String payload) {
    restartApp();
  }

  // We are using async callback for using await
  Future<void> bluetoothConnectionState() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // For knowing when bluetooth is connected and when disconnected
    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case FlutterBluetoothSerial.CONNECTED:
          blue.setConnected(true);
          blue.setPressed(false);
          break;

        case FlutterBluetoothSerial.DISCONNECTED:
          blue.setConnected(false);
          blue.setPressed(false);
          break;

        default:
          print(state);
          break;
      }
    });

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();
          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                currentLocation = result;
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      currentLocation = location;
    });

    if (currentLocation.accuracy <= 50.0) {
      sendData('{"request":"location", "latitude": "' + currentLocation.latitude.toString() + '", "longitude": "' + currentLocation.longitude.toString() +'"}');
    }

    slowRefresh();
  }

  slowRefresh() async {
    _locationSubscription.cancel();
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 10000);
    _locationSubscription =
        _locationService.onLocationChanged().listen((LocationData result) {
      if (mounted) {
        double latDiff = (result.latitude - currentLocation.latitude).abs();
        double longDiff = (result.longitude - currentLocation.longitude).abs();
        if (latDiff >= 0.001 || longDiff >= 0.001) {
          setState(() {
            currentLocation = result;
          });
          if (currentLocation.accuracy <= 50.0) {
            sendData('{"request":"location", "latitude": "' + currentLocation.latitude.toString() + '", "longitude": "' + currentLocation.longitude.toString() +'"}');
          }
        } else {
          slowRefresh();
        }
      }
    });
  }

  _onTap(int index) {
    setState(() => _currIndex = index);
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          // return new DataPage(data: 'Home');
          return NoteList();
        }));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          // return new DataPage(data: 'Bluetooth');
          return blue.BluetoothApp();
          //return MyAppBluetooth();
        }));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          //return new DataPage(data: 'Profile');
          return ProfilePage();
        }));
        break;
      case 3:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          //return new DataPage(data: 'Settings');
          return SwitchExample();
        }));
        break;
      default:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new DataPage(data: 'Home');
          //return ExpandableListView();
        }));
    }
  }

  var assetsImage = new AssetImage('assets/restaurant.png');

  getDecodingPredictList() {
    var list = new List();
    print(jsonPredictData);
    if (jsonPredictData != null){
      print(jsonPredictData['request']);
      if (jsonPredictData['request'] == 'predict'){
        String details = "Address: " + jsonPredictData['address'];
        list.add(jsonPredictData['name']);
        list.add(details);
      }

    }
    else{
      list.add("Prediction Places");
      list.add("No Places Predict Untill Now");
    }
    return (list);
  }

  getDecodingSuggestList() {
    var list = new List();
    if (jsonSuggestData != null){
      if (jsonSuggestData['request'] == 'suggest') {
        String details = "Type: " +
            jsonSuggestData['type'] +
            "\nRate: " +
            jsonSuggestData['rate'] +
            "\nAddress: " +
            jsonSuggestData['address'];
        print(details);
        list.add(jsonSuggestData['name']);
        list.add(details);
      }
    }
    else{
      list.add("Suggestion Places");
      list.add("No Places Suggest Untill Now");
    }
    return (list);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //Colors.lightBlue[100],
      backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      appBar: AppBar(
        title: Text("Companion"),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset('assets/background.png',
            width: size.width, height: size.height, fit: BoxFit.fill),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 170.0, bottom: 0.0, right: 10, left: 10),
            child: Card(
              shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
              color: Color.fromRGBO(255, 255, 255, 1.0),
              elevation: 4.0,
              child: ListTile(
                  leading: Icon(Icons.location_on,size:40,color:Colors.red,),
                  title: Text(getDecodingSuggestList()[0],textScaleFactor: 1.5,style:TextStyle(fontWeight:FontWeight.bold,fontStyle:FontStyle.italic,color:Colors.red )),
                  subtitle: Text(getDecodingSuggestList()[1],textScaleFactor: 1.2,style:TextStyle(fontWeight:FontWeight.bold,color:Colors.black87),)),
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.only(top: 310.0, bottom: 0.0, right: 10, left: 10),
              child: Card(
              shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                color: Color.fromRGBO(255, 255, 255, 1.0),
                elevation: 4.0,
                child: ListTile(
                    leading: Icon(Icons.location_on,size:40,color:Colors.blue,),
                    title: Text(getDecodingPredictList()[0],textScaleFactor: 1.5,style:TextStyle(fontWeight:FontWeight.bold,fontStyle:FontStyle.italic,color:Colors.blue )),
                  subtitle: Text(getDecodingPredictList()[1],textScaleFactor: 1.2,style:TextStyle(fontWeight:FontWeight.bold,color:Colors.black87),)),
              ))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,

        currentIndex: _currIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            //backgroundColor: Colors.black,
            icon: Icon(Icons.home,color:Colors.white),
            title: Text("Meetings",style:TextStyle(color:Colors.white)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth,color:Colors.white),
            title: Text("Bluetooth",style:TextStyle(color:Colors.white)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color:Colors.white),
            title: Text("Profile",style:TextStyle(color:Colors.white)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,color:Colors.white),
            title: Text("Settings",style:TextStyle(color:Colors.white)),
          ),
        ],
        onTap: _onTap,
      ),
    );
  }
}

class DataPage extends StatelessWidget {
  final String data;

  const DataPage({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      appBar: AppBar(title: Text("Data Page")),
      body: Center(
          child: new Image.asset('assets/background.png',
             width: size.width, height: size.height, fit: BoxFit.fill),
        // child: Text(data,
        // style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))
        ),
    );
  }
}
