import 'package:flutter/material.dart';
import 'package:notecho/TextToSpeechAPI.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:notecho/voice.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
class SelectIMG extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelectIMGState();
}

class SelectIMGState extends State {
  RegExp reg = RegExp(r"[0-9]*[0-9]:[0-9][0-9]$");
  RegExp reg1 = RegExp(r"[0-9][0-9]%$");
 List<Voice> _voices = [];
  Voice _selectedVoice;
  AudioPlayer audioPlugin = AudioPlayer();
  final TextEditingController _filename = TextEditingController();
  String _extractText = '';
  String filepath ='';
  File pickedImage;
  final picker = ImagePicker();
  bool isImageLoaded = false;
  initState() {
    super.initState();
    getVoices();
  }
Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    for (TextBlock block in readText.blocks) {

      for (TextLine line in block.lines) {
        if(!(reg.hasMatch(line.text) | reg1.hasMatch(line.text))){
        for (TextElement word in line.elements) {
          setState(() {
            _extractText = _extractText + word.text + ' ';
          });
        }
        _extractText = _extractText + '\n';
        }
      }
    }
  }
Future pickImage() async {
    var tempStore = await picker.getImage(source:ImageSource.gallery );
    setState(() {
      pickedImage = File(tempStore.path);
      isImageLoaded = false;
    });
    readText();
  }
  void synthesizeText(String text, String name) async {
      final String audioContent = await TextToSpeechAPI().synthesizeText(text, _selectedVoice.name, _selectedVoice.languageCodes.first);
      if (audioContent == null) return;
      final bytes = Base64Decoder().convert(audioContent, 0, audioContent.length);
      final dir = await getExternalStorageDirectory();
      final file = File('${dir.path}/Songs/$name.mp3');
      await file.writeAsBytes(bytes);
  }
  
  void getVoices() async {
    final voices = await TextToSpeechAPI().getVoices();
    if (voices == null) return;
    setState(() {
      _selectedVoice = voices.firstWhere((e) => e.name == 'en-US-Wavenet-F' && e.languageCodes.first == 'en-US', orElse: () => Voice('en-US-Wavenet-F', 'FEMALE', ['en-US']));
      _voices = voices;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('notecho'),
      ),
      body: SingleChildScrollView(child:
        Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: DropdownButton<Voice>(
              value: _selectedVoice,
              hint: Text('Select Voice'),
              items: _voices.map((f) => DropdownMenuItem(
                value: f,
                child: Text(' ${f.languageCodes.first} - ${f.gender}'),
              )).toList(),
              onChanged: (voice) {
                setState(() {
                  _selectedVoice = voice;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: RaisedButton(
                      child: Text('Select File:'),
                      onPressed: pickImage
                    ),
          ),
           Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: TextField(
              autofocus: true,
              controller: _filename,
              maxLines: null,
              decoration: InputDecoration(
                  hintText: 'Please enter File name:'
              ),
            ),
          ),
          
        ])
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4.0,
        child: Icon(Icons.audiotrack),
        onPressed: () async{
          final text = _extractText;
          final name = _filename.text;
          if (text.length == 0 || _selectedVoice == null) return;
          synthesizeText(text,name);
          Navigator.pop(context, true);
        },
      ),
    );
  }

}