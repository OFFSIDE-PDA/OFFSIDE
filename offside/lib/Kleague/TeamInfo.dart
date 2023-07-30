import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeamInfo extends StatefulWidget {
  const TeamInfo({
    Key? key,
    required this.team,
  }) : super(key: key);

  final int team;

  @override
  State<TeamInfo> createState() => _TeamInfo();
}

class _TeamInfo extends State<TeamInfo> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return (Text((widget.team).toString()));
  }
}
