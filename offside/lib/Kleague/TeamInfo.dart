import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeamInfo extends StatefulWidget {
  const TeamInfo({super.key});

  @override
  State<TeamInfo> createState() => _TeamInfo();
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "OFFSIDE",
//       routes: {
//         "/": (context) => TeamInfo(),
//       },
//     );
//   }
// }

class _TeamInfo extends State<TeamInfo> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return (Text("Hello"));
    // TODO: implement build
    throw UnimplementedError();
  }
}
