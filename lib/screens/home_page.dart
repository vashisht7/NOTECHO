
import 'package:flutter/material.dart';
import 'package:notecho/screens/playlist.dart';
class HomePage extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
      'NOTECHO',
     style: TextStyle(
           fontSize: 22,
           fontWeight: FontWeight.w600,
         ))
     ),
      backgroundColor: Colors.white,
      body: 
          PlayList(), //use this or ScrollableExhibitionSheet
      );
    
  }
}

// class Header extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(
//         'Shenzhen',
//         style: TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.w600,
//         ))
//     )) ;
//   }
// }
