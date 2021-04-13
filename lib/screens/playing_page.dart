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
  Duration _duration = new Duration();
  Duration _position = new Duration();
  String currentTime = "00:00";
  String completeTime = "00:00";
  static bool favourited = true;
  static bool active = false;
  File pathtofile;
  int index;
  //static bool playing = false;
  Future _play(pathtofile) async {
    var result = await _audioPlayer.play(pathtofile.path, isLocal: true);
    if (result == 1)
      setState(() {
        isPlaying = true;
      });
  }

  void seekToSeconds(int second) {
    Duration newDuration = Duration(seconds: second);
    _audioPlayer.seek(newDuration);
  }

  @override
  void initState() {
    super.initState();

    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = duration.toString().split(".")[0];
        _position = duration;
      });
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        completeTime = duration.toString().split(".")[0];
        _duration = duration;
      });
    });
    setState(() {
      index = widget.index;
    });
    print(widget.songs[widget.index].audioPath);
    pathtofile = File(widget.songs[widget.index].audioPath);
    _play(pathtofile);
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentTime == completeTime) {
      isPlaying = false;
    }
    //index = widget.index;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Add one stop for each color. Stops should increase from 0 to 1
            colors: [Color(0xFFFFFFFF), Colors.amber],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                FileImage(File(widget.songs[index].imagePath)),
                            fit: BoxFit.fitHeight))),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 20.0,),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(right: 13.0),
                        child: Text(
                          widget.songs[index].description,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Slider(
                        activeColor: Colors.black,
                        inactiveColor: Colors.grey,
                        value: _position.inSeconds.toDouble(),
                        max: _duration.inSeconds.toDouble(),
                        onChanged: (double value) {
                          setState(() {
                            seekToSeconds(value.toInt());
                            value = value;
                          });
                        },
                      ),
                      flex: 3,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          favourited = !favourited;
                        });
                      },
                      child: Icon(
                        favourited ? Icons.favorite : Icons.favorite_border,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.shuffle),
                    GestureDetector(
                      onTap: () {
                        print(widget.songs[widget.index].audioPath);
                        if (index - 1 >= 0) {
                          setState(() {
                            index = index - 1;
                          });
                          pathtofile =
                              File(widget.songs[widget.index].audioPath);
                          _play(pathtofile);
                        }
                      },
                      child: Icon(
                        Icons.skip_previous,
                        size: 50.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
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
                      child: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        size: 90.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (index + 1 < widget.songs.length) {
                          setState(() {
                            index = index + 1;
                          });
                          print(index);
                          pathtofile =
                              File(widget.songs[widget.index].audioPath);
                          _play(pathtofile);
                        }
                      },
                      child: Icon(
                        Icons.skip_next,
                        size: 50.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          active = !active;
                        });
                      },
                      child: Icon(
                        Icons.repeat,
                        color: active ? Colors.green : Colors.white,
                      ),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     Icon(
                //       Icons.devices,
                //       color: Colors.grey,
                //     ),
                //     Icon(
                //       Icons.list,
                //       color: Colors.grey,
                //     )
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'NOTECHO',
              style: TextStyle(
                letterSpacing: 1.0,
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
              ),
            ),
            Text('Playing    ' + widget.songs[widget.index].title)
          ],
        ),
        backgroundColor: Color(0xff3E4852),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_down,
            size: 40.0,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.more_vert,
              size: 30.0,
            ),
          )
        ],
      ),
    );
  }
}
