import 'package:flutter/material.dart';
import 'package:notecho/screens/playlist.dart';
import 'package:notecho/onboardingPages/onBoardingPages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notecho/screens/menu.dart';

int initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen $initScreen');
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
 
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'AUOTODIDACT',
      debugShowCheckedModeBanner: false,
      home: initScreen==0 ||initScreen==null? OnBoard():Menu(child: MyHomePage(title: 'notecho',),) ,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title ,textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: PlayList()
    );
  }
  
  }


