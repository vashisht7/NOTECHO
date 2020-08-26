import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File pickedImage;

  bool isImageLoaded = false;

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
        }
      }
    }
  }

  Future decode() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    List barCodes = await barcodeDetector.detectInImage(ourImage);

    for (Barcode readableCode in barCodes) {
      print(readableCode.displayValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        SizedBox(height: 100.0),
        isImageLoaded
            ? Center(
                child: Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(pickedImage), fit: BoxFit.cover))),
              )
            : Container(),
        SizedBox(height: 10.0),
        RaisedButton(
          child: Text('Pick an image'),
          onPressed: pickImage,
        ),
        SizedBox(height: 10.0),
        RaisedButton(
          child: Text('Read Text'),
          onPressed: readText,
        ),
        RaisedButton(
          child: Text('Read Bar Code'),
          onPressed: decode,
        )
      ],
    ));
  }
}


// Card(
//             margin: EdgeInsets.only(top: 2, left: 2, right: 2, bottom: 2),
//             elevation: 8,
//             color: Colors.grey,
//             child: ListTile(
//               leading: CircleAvatar(
//                   backgroundImage: AssetImage('assets/bubble.jpeg')),
//               trailing: Icon(
//                 isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
//                 color: Colors.grey,
//                 size: 40.0,
//               ),
//               onTap: () async {
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => PlayingPage(
//                             index: inx,
//                             songs: songs,
//                             dirr: dirr,
//                           )),
//                 );
//               },
//               // setState(() {
//               //   isPlaying ? _stop() : _play(File('${dirr.path}/${p.basename(this.songs[inx].toString()).split('.')[0]}.mp3'));
//               // });
//               title: Text(p.basename(this.songs[inx].toString()).split('.')[0],
//                   style: TextStyle(fontSize: 20, color: Colors.black)),
//             ),
//           );