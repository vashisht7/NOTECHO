import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:notecho/screens/selectImg.dart';
import 'package:path/path.dart' as p;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notecho/screens/playing_page.dart';

class PlayList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlayListState();
}

class PlayListState extends State {
  bool isPlaying = false;
  //AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  List songs= new List();
  List files= new List();
  int count =0;
  var dirr;
  
  @override
   void initState() {
    super.initState();
  }
  getList() async{
    final dir = await getExternalStorageDirectory();
    final Directory finaldir = Directory(dir.path+"/Songs");
    setState(() {
                   songs= finaldir.listSync();
                  count = songs.length;
                  dirr = finaldir;
                });
               
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: playlistitems(),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          navigateToDetail();
        }
        ,
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
        return Card(
          margin: EdgeInsets.only(top:2,left: 2, right: 2, bottom: 2),
          elevation: 8,
          color: Colors.grey,
          child: ListTile(
            leading: CircleAvatar(backgroundImage: AssetImage('assets/bubble.jpeg')),
            trailing:  Icon( isPlaying ?FontAwesomeIcons.pause:FontAwesomeIcons.play,color: Colors.grey,size: 40.0,), 
            onTap: () async{
              await Navigator.push(context, 
        MaterialPageRoute(builder: (context) => PlayingPage(index: inx,songs: songs,dirr: dirr,)),
    );
            },
                // setState(() {
                //   isPlaying ? _stop() : _play(File('${dirr.path}/${p.basename(this.songs[inx].toString()).split('.')[0]}.mp3'));
                // });
          title: Text(p.basename(this.songs[inx].toString()).split('.')[0],style:TextStyle(fontSize: 20,color: Colors.black)),
          ),
        );
       }
    );
  }
  
  void navigateToDetail() async {
     await Navigator.push(context, 
        MaterialPageRoute(builder: (context) => SelectIMG()),
    );
  }
}