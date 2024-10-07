class Notes {
  int _id = 0; // Default value
  String _title = ''; // Default value
  String _desc = ''; // Default value
  String _date = ''; // Default value
  int _priority = 0; // Default value

  Notes(this._title, this._date, this._priority, this._desc);
  Notes.withId(this._id, this._title, this._date, this._priority, this._desc);

  int get id => _id;
  String get title => _title;
  String get desc => _desc;
  int get priority => _priority;
  String get date => _date;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set desc(String newDesc) {
    if (newDesc.length <= 255) {
      _desc = newDesc;
    }
  }

  set date(String newDate) {
    if (newDate.length <= 255) {
      _date = newDate;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    // if(_id != null){map['id'] = _id;}

    map['id'] = _id;
    map['title'] = _title;
    map['desc'] = _desc;
    map['priority'] = _priority;

    return map;
  }

  //extract the note object from a Map object

  Notes.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _date = map['date'];
    _priority = map['priority'];
    _title = map['title'];
    _desc = map['desc'];
  }
}
