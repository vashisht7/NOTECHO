import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

class PlayingPage extends StatefulWidget {
  final List songs;
  final int index;
  final dirr;
  PlayingPage({Key key, this.index, this.songs, this.dirr}) : super(key: key);
  @override
  _PlayingPageState createState() => _PlayingPageState();
}

class _PlayingPageState extends State<PlayingPage> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentTime = "00:00";
  String completeTime = "00:00";

  Future _play(pathtofile) async {
    var result = await _audioPlayer.play(pathtofile.path, isLocal: true);
    if (result == 1)
      setState(() {
        isPlaying = true;
      });
  }

  @override
  void initState() {
    
    super.initState();

    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = duration.toString().split(".")[0];
      });
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        completeTime = duration.toString().split(".")[0];
      });
    });
    File pathtofile = File(
        '${widget.dirr.path}/${p.basename(widget.songs[widget.index].toString()).split('.')[0]}.mp3');
    _play(pathtofile);
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Image.asset(
            "assets/12.jpg",
            fit: BoxFit.contain,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 80,
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.7,
                left: MediaQuery.of(context).size.width * 0.1),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (isPlaying) {
                      _audioPlayer.pause();

                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      _audioPlayer.resume();

                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                ),
                SizedBox(
                  width: 16,
                ),
                IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: () {
                    _audioPlayer.stop();

                    setState(() {
                      isPlaying = false;
                    });
                  },
                ),
                Text(
                  currentTime,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(" | "),
                Text(
                  completeTime,
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
