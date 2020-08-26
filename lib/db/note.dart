class Note{
  int _id;
  String _filename;
  String _desc;


  Note(this._filename,[this._desc]);
  Note.withId(this._id,this._filename,[this._desc]);
  int get id =>_id;
  String get title => _filename;
  String get description => _desc;

  set title(String newTitle){
    if(newTitle.length<=255)
    _filename=newTitle;
  }
  set description(String newDescription){
    if(newDescription.length<=255)
    _desc=newDescription;
  }

  Map <String, dynamic> toMap(){
    var map =Map<String, dynamic>();
    map["filename"] = _filename;
    map["description"] = _desc;
    if(_id!=null){
      map["id"]=_id;
    }
return map;
  }

  Note.fromObject(dynamic o){
    this._id=o["id"];
    this._filename= o["filename"];
    this._desc = o["description"];
  }
}