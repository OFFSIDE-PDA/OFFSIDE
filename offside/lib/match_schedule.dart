import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:offside/Kleague/kLeague.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MatchDataWidget(),
    );
  }
}

class MatchDataWidget extends StatefulWidget {
  const MatchDataWidget({super.key});

  @override
  State<MatchDataWidget> createState() => _MatchDataWidget();
}

class _MatchDataWidget extends State<MatchDataWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
