class Note {
  int _id;
  String _title;
  String _description;
  String _imagePath;
  String _audioPath;

  Note(this._title, this._imagePath, this._audioPath, [this._description]);
  Note.withId(this._id, this._title, this._imagePath, this._audioPath,
      [this._description]);

// All the getters
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get imagePath => _imagePath;
  String get audioPath => _audioPath;

  // All the setter
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set imagePath(String newimagePath) {
    this._imagePath = newimagePath;
  }

  set audioPath(String newaudioPath) {
   
      this._audioPath = newaudioPath;
    
  }

  //Used to save and retrive from database

//convert note object to map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['imagePath'] = _imagePath;
    map['audioPath'] = _audioPath;
    
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._audioPath = map['audioPath'];
    this._imagePath = map['imagePath'];
  }
}
