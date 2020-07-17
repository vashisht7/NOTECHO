import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:notecho/main.dart';
import 'package:notecho/screens/menu.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class OnBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  void createFolder() async {
    final dir = await getExternalStorageDirectory();
    final Directory filepath = Directory('${dir.path}/Songs');
    await filepath.create(recursive: true);
  }

  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => Menu(
                child: MyHomePage(title: 'notecho'),
              )),
    );
  }

  Widget _buildImage(String assetName) {
    return Center(
      child: Image(
        image: AssetImage(
          'assets/$assetName.jpg',
        ),
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    createFolder();
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.all(10.0),
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Select a File",
          body: "Select a file from your gallery,which contains text.",
          image: _buildImage('gallery'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Learn in your favorite language",
          body:
              "Select the language and the voice in which you want to listen the file.",
          image: _buildImage('audioBook'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Make a Playlist",
          body:
              "Make a playlist of the files you want to learn and listen as Songs.",
          image: _buildImage('audioBookCoffee'),
          decoration: pageDecoration,
        ),
        // PageViewModel(
        //   title: "Another title page",
        //   body: "Another beautiful body text for this example onboarding",
        //   image: _buildImage('audioBookCoffee'),
        //   footer: RaisedButton(
        //     onPressed: () {
        //       introKey.currentState?.animateScroll(0);
        //     },
        //     child: const Text(
        //       'FooButton',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //     color: Colors.lightBlue,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8.0),
        //     ),
        //   ),
        //   decoration: pageDecoration,
        // ),
        PageViewModel(
          title: "Learn as you go.",
          body: "Listen and learn even when you are travelling...",
          image: _buildImage('travellingGuy'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
