import 'package:flutter/material.dart';
import 'package:companion/models/note.dart';
import 'package:companion/screens/bluetooth_controller.dart';
import 'package:companion/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High', 'Low'];
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = note.title;
    locationController.text = note.location;
    timeController.text = note.time;
    dateController.text = note.date;
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Stack(children: <Widget>[
            Center(
              child: new Image.asset('assets/background.png',
                  width: size.width, height: size.height, fit: BoxFit.fill),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: ListView(
                children: <Widget>[
                  // First element
                  ListTile(
                    dense: true,
                    title:  DropdownButton(
                        items: _priorities.map((String dropDownStringItem){
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                      
                        style: TextStyle(color:Colors.white,fontSize:20),
                        value: getPriorityAsString(note.priority),
                        onChanged: (valueSelectedByUser) {
                          setState(() {
                            debugPrint('User selected $valueSelectedByUser');
                            updatePriorityAsInt(valueSelectedByUser);
                          });
                        })),
                  // Second Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: titleController,
                      style: TextStyle(color:Colors.white,fontSize:20),
                      onChanged: (value) {
                        debugPrint('Something changed in Title Text Field');
                        updateTitle();
                      },
                      decoration: InputDecoration(

                          labelText: 'Title',
                          labelStyle: TextStyle(color:Colors.white,fontSize:20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                  ),

                  // Third Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: locationController,
                      style: TextStyle(color:Colors.white,fontSize:20),
                      onChanged: (value) {
                        debugPrint('Something changed in Location Text Field');
                        updateLocation();
                      },
                      decoration: InputDecoration(
                          labelText: 'Location',
                          labelStyle: TextStyle(color:Colors.white,fontSize:20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                  ),

                  // Third Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: dateController,
                      style: TextStyle(color:Colors.white,fontSize:20),
                      onChanged: (value) {
                        debugPrint('Something changed in Location Text Field');
                        updateDate();
                      },
                      decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: TextStyle(color:Colors.white,fontSize:20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                  ),

                  // Third Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: timeController,
                      style: TextStyle(color:Colors.white,fontSize:20),
                      onChanged: (value) {
                        debugPrint('Something changed in Location Text Field');
                        updateTime();
                      },
                      decoration: InputDecoration(
                          labelText: 'Time',
                          labelStyle: TextStyle(color:Colors.white,fontSize:20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                  ),

                  // Fourth Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Colors.black,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0)),
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Save button clicked");
                                _save();
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Colors.black,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0)),
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Delete button clicked");
                                _delete();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateLocation() {
    note.location = locationController.text;
  }

  // Update the description of Note object
  void updateTime() {
    note.time = timeController.text;
  }

  // Update the description of Note object
  void updateDate() {
    note.date = dateController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();
    int result;
    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Event Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Event');
    }
    String data = '{"request":"create", "location": "' +
        note.location +
        '", "date": "' +
        note.date +
        '" , "time": "' +
        note.time +
        '"}';
    sendData(data);
  }

  void _delete() async {
    moveToLastScreen();
    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Event was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Event Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Event');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
      title: Text(title,style:TextStyle(fontWeight:FontWeight.bold,color:Colors.black)),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
