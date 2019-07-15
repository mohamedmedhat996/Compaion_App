import 'dart:async';
import 'package:flutter/material.dart';
import 'package:companion/models/note.dart';
import 'package:companion/utils/database_helper.dart';
import 'package:companion/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';

class ProfileList extends StatefulWidget {

	@override
  State<StatefulWidget> createState() {

    return ProfileListState();
  }
}

class ProfileListState extends State<ProfileList> {

	DatabaseHelper databaseHelper = DatabaseHelper();
	List<Note> noteList;
	int count = 0;

	@override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
		if (noteList == null) {
			noteList = List<Note>();
			updateListView();
		}
    
    return Scaffold(
      //backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
	    appBar: AppBar(
		    title: Text('Profile Page'),
        
	    ),

	    body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset('assets/background.png',
            width: size.width, height: size.height, fit: BoxFit.fill),
          ),
          getNoteListView(),
        ]),          

	    floatingActionButton: FloatingActionButton(
        foregroundColor:Colors.white ,
        backgroundColor: Colors.black,
		    onPressed: () {
		      debugPrint('FAB clicked');
		      navigateToDetail(Note('', '', 2,'',''), 'Add Note');

        },

		    tooltip: 'Add Note',
		    child: Icon(Icons.add),

	    ),
    );
  }

  ListView getNoteListView() {
		TextStyle titleStyle = Theme.of(context).textTheme.subhead;
		return ListView.builder(
			itemCount: count,
			itemBuilder: (BuildContext context, int position) {
        var body = "Location: " + this.noteList[position].location + 
            "\nDate: " + this.noteList[position].date + 
            "\nTime: " + this.noteList[position].time;
				return Card(
          color: Colors.transparent,
					elevation: 20.0,
					child: ListTile(
						leading: CircleAvatar(
							backgroundColor: getPriorityColor(this.noteList[position].priority),
							child: getPriorityIcon(this.noteList[position].priority),
						),
						title: Text(this.noteList[position].title, style: TextStyle(fontWeight:FontWeight.bold,color:Colors.white),textScaleFactor: 1.5,),
						subtitle: Text(body,style: TextStyle(color:Colors.white),textScaleFactor: 1.2,),
						trailing: GestureDetector(
							child: Icon(Icons.delete, color: Colors.grey,),
							onTap: () {
								_delete(context, noteList[position]);
							},
						),
						onTap: () {
							debugPrint("ListTile Tapped");
							navigateToDetail(this.noteList[position],'Edit Note');
						},
					),
				);
			},
		);
  }

  // Returns the priority color
	Color getPriorityColor(int priority) {
		switch (priority) {
			case 1:
				return Colors.lightBlue[1];
				break;
			case 2:
				return Colors.lightBlue[50];
				break;
			default:
				return Colors.yellow;
		}
	}

	// Returns the priority icon
	Icon getPriorityIcon(int priority) {
		switch (priority) {
			case 1:
				return Icon(Icons.play_arrow);
				break;
			case 2:
				return Icon(Icons.keyboard_arrow_right);
				break;

			default:
				return Icon(Icons.keyboard_arrow_right);
		}
	}

	void _delete(BuildContext context, Note note) async {
		int result = await databaseHelper.deleteNote(note.id);
		if (result != 0) {
			_showSnackBar(context, 'Note Deleted Successfully');
			updateListView();
		}
	}

	void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
	}

  void navigateToDetail(Note note, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return NoteDetail(note, title);
	  }));
	  if (result == true) {
	  	updateListView();
	  }
  }

  void updateListView() {
		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {
			Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
			noteListFuture.then((noteList) {
				setState(() {
				  this.noteList = noteList;
				  this.count = noteList.length;
				});
			});
		});
  }
}







