import 'dart:convert';
import 'package:companion/models/note.dart';
import 'package:companion/screens/bottom_Nav.dart';
import 'package:companion/utils/database_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


// int _id = 1;
String _title = "";
String _date = "";
int _priority = 3;
String _location = "";
String _time = "";
String s = "";

Note note = new Note(_title, _date, _priority, _location, _time);
// Note note = new Note.withId(_id, _title, _date, _priority, _location, _time);
DatabaseHelper helper = DatabaseHelper();


// Method to receive message,
Future<void> receiveStreaming() async {
  await bluetooth.isConnected.then((isConnected){
    if (isConnected) {
      Stream<String> result = bluetooth.onRead();
      result.listen((value) {
        // Handel JSON and Notification Here
        // value = "{'request':'create', 'location': 'Cairo', 'date': 'Monday', 'time': '4 PM'}"
        // value = "{'request':'change', 'location': 'Cairo', 'date': 'Monday', 'time': '4 PM'}"
        // value = "{'request':'delete', 'location': 'Cairo', 'date': 'Monday', 'time': '4 PM'}"
        // value = "{'request':'suggest', 'type': 'Restaurant', 'name': 'Abo Mazen', 'rate': 2.3, 'address': 'Al Manyal ....'}"
        // value = "{'request':'predict', 'name': 'Giza', 'address': '14 Mas we El Sodan Street'}"
        print("Received: $value");
        String test = "";
        if (value == "1"){
          test = '{"request":"create", "location": "KFC", "date": "Monday", "time": "4 PM"}';
          showNotification("note.title", "note.location", "note.date", "r");
          dddde();
        }
        else if (value == "2"){
          test = '{"request":"suggest", "type": "Restaurant", "name": "Pizza Hut", "rate": "4.5", "address": "73 Rd 9, Maadi Al Khabiri Ash Sharqeyah, Maadi, Cairo Governorate"}';
        }
        else if (value == "3"){
          test = '{"request":"predict", "name": "City Centre Maadi", "address": "Ring Rd, El-Basatin Sharkeya, El Basatin, Cairo Governorate"}';
        }
        else{receiveStreaming();}
        var dataReceive = json.decode(test);
        String request = dataReceive["request"];
        print(request);
        
        if (request == "create") {
          // Create Function
          _create(dataReceive);
        } 
        else if (request == "change") {
          // Change Function
          _change(dataReceive);
        } 
        else if (request == "delete") {
          // Delete Function
          _delete(dataReceive);
        } 
        else if (request == "suggest") {
          // Suggest Function
          _suggest(dataReceive);
        } 
        else if (request == "predict") {
          // Predict Function
          _predict(dataReceive);
        } 
        else {
        }
      });
    }
    else {receiveStreaming();}
  });
}

void _create(dataReceive) async{
  note.title = "Meeting";
  note.location = dataReceive['location'];
  note.date = dataReceive['date'];
  note.time = dataReceive['time'];
  // note.location = "Cairo";
  // note.date = "Monday";
  // note.time = "4 PM";
  print(note.location + " " + note.date + " " + note.time);
  int result = await helper.insertNote(note);
  if (result != 0) {  // Success
    print('Note Saved Successfully');
    showNotification(note.title, note.location, note.date, note.time);
  } else {  // Failure
    print('Problem Saving Note');
  }
}

void _change(var dataReceive) async{
  note.title = "Changing in Meeting";
  note.location = dataReceive['location'];
  note.date = dataReceive['date'];
  note.time = dataReceive['time'];
  // Update operation
	int result = await helper.updateNote(note);
  if (result != 0) {  // Success
    print('Note Saved Successfully');
    showNotification(note.title, note.location, note.date, note.time);
  } else {  // Failure
    print('Problem Saving Note');
  }
}

void _delete(var dataReceive) async{

}
 
void _suggest(var dataReceive) async{
  await updateSuggestData(dataReceive);
}
 
void _predict(var dataReceive) async{
  await updatePredictData(dataReceive);
}



// Method to send message,
void sendData(String data) async {
  // data = '{"request":"location", "latitude": 31.054952, "longitude": 30.254885}';
  // data = '{"request":"create", "location": "Cairo", "date": "Monday", "time": "4 PM"}';
  bluetooth.isConnected.then((isConnected) {
    //show("Send Data");
    print("Send Data");
    if (isConnected) {
      bluetooth.write(data + "\n");
      print(data);
      // show('Sending Data Done');
      print('Sending Data Done');
    } else {
      // show('Error in Sending Data');
      print('Error in Sending Data');
    }
  });
}

// Show Notification
showNotification(String title, String location, String date, String time) async {
  print("NOOOOOOOOOOOOOTeeeeeeeeeeeeeeeeeeeeeeeeee");
  String notificationMassage =
      "Location: " + location + ",  Date: " + date + ",  Time: " + time;
  var android = new AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.High, importance: Importance.Max);
  var iOS = new IOSNotificationDetails();
  var platform = new NotificationDetails(android, iOS);
  print("FRIST");
  await flutterLocalNotificationsPlugin.show(0, title , notificationMassage, platform);
  print("object");
}

dddde() async {
  var android = new AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.High,importance: Importance.Max
  );
  var iOS = new IOSNotificationDetails();
  var platform = new NotificationDetails(android, iOS);
  await flutterLocalNotificationsPlugin.show(
      0, 'New Video is out', 'Flutter Local Notification', platform,
      payload: 'Nitish Kumar Singh is part time Youtuber');
}

