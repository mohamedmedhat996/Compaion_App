class Note {
	int _id;
	String _title;
  String _location;
	String _date;
	String _time;
	int _priority;

  Note(this._title, this._date, this._priority,this._location, this._time,);
	Note.withId(this._id, this._title, this._date, this._priority,this._location, this._time);

	int get id => _id;
	String get title => _title;
  String get location => _location;
	int get priority => _priority;
	String get date => _date;
	String get time => _time;

	set title(String newTitle) {
		if (newTitle.length <= 255) {
			this._title = newTitle;
		}
	}

	set location(String newLocation) {
		if (newLocation.length <= 255) {
			this._location = newLocation;
		}
	}

	set priority(int newPriority) {
		if (newPriority >= 1 && newPriority <= 2) {
			this._priority = newPriority;
		}
	}

	set date(String newDate) {
		this._date = newDate;
	}

	set time(String newTime) {
		this._time = newTime;
	}


	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {
		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['title'] = _title;
		map['location'] = _location;
		map['priority'] = _priority;
		map['date'] = _date;
		map['time'] = _time;
		return map;
	}

	// Extract a Note object from a Map object
	Note.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._title = map['title'];
    this._location = map['location'];
		this._priority = map['priority'];
		this._date = map['date'];
		this._time = map['time'];
	}
}


/*class Profile {
	int _id;
  String _name;
  String _email;
  String _mobile;

  Profile(this._name,this._email,this._mobile);
	Profile.withId(this._id,this._name,this._email,this._mobile);

	int get id => _id;
  String get name => _name;
  String get email => _email;
  String get mobile => _mobile;

	set name(String newName) {
		if (newName.length <= 255) {
			this._name = newName;
		}
	}

	set email(String newEmail) {
		if (newEmail.length <= 255) {
			this._email = newEmail;
		}
	}

  set mobile(String newMobile) {
		if (newMobile.length <= 255) {
			this._mobile = newMobile;
		}
	}

	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {
		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['name'] = _name;
		map['email'] = _email;
		map['mobile'] = _mobile;
		return map;
	}

	// Extract a Note object from a Map object
	Profile.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._name = map['name'];
    this._email = map['email'];
		this.mobile = map['mobile'];
}
}*/