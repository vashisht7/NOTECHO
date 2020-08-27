import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:notecho/screens/selectImg.dart';
import 'package:path/path.dart' as p;
import 'package:notecho/screens/playing_page.dart';
import 'package:notecho/db/note.dart';
import 'package:notecho/db/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class PlayList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlayListState();
}

class PlayListState extends State {
  bool isPlaying = false;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int notecount = 0;
  //AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  List songs = new List();
  List files = new List();
  int count = 0;
  var dirr;

  @override
  void initState() {
    super.initState();
  }

  getList() async {
    final dir = await getExternalStorageDirectory();
    final Directory finaldir = Directory(dir.path + "/Songs");
    setState(() {
      songs = finaldir.listSync();
      count = songs.length;
      dirr = finaldir;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: playlistitems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note('', '', ''));
        },
        tooltip: "Add new Quote",
        child: new Icon(Icons.add),
      ),
    );
  }

  ListView playlistitems() {
    getList();
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int inx) {
          return _customcard(context, inx);
        });
  }

  void navigateToDetail(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectIMG(note)),
    );
  }

  Widget _customcard(BuildContext context, int index) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Container(
                    child: Image.asset(
                  'assets/bubble.jpeg',
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                )),
                // trailing: Icon(
                //   isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                //   color: Colors.grey,
                //   size: 40.0,
                // ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlayingPage(
                              index: index,
                              songs: songs,
                              dirr: dirr,
                            )),
                  );
                },
                // setState(() {
                //   isPlaying ? _stop() : _play(File('${dirr.path}/${p.basename(this.songs[inx].toString()).split('.')[0]}.mp3'));
                // });
                title: Text(
                  p.basename(this.songs[index].toString()).split('.')[0],
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              //SizedBox(height: 5.0,),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Text(
                        'This is a description',
                        textDirection: TextDirection.ltr,
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlayingPage(
                                    index: index,
                                    songs: songs,
                                    dirr: dirr,
                                  )),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initalizeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.notecount = noteList.length;
        });
      });
    });
  }
}
