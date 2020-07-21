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
    if (currentTime == completeTime) {
      isPlaying = false;
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // Add one stop for each color. Stops should increase from 0 to 1

            colors: [Color(0xFFFFFFFF), Color(0xFFFF9800)],
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
                  height: 100.0,
                ),
                Material(
                  elevation: 10.0,
                  child: Image.asset(
                    'assets/color.jpeg',
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.9,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 100.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Intro',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'J. Cole',
                          style: TextStyle(fontSize: 19.0, color: Colors.grey),
                        ),
                      ],
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
                Slider(
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
                    Icon(
                      Icons.skip_previous,
                      size: 50.0,
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
                    Icon(
                      Icons.skip_next,
                      size: 50.0,
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
            Text('Playing    ' +
                p.basename(widget.songs[widget.index].toString()).split('.')[0])
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
