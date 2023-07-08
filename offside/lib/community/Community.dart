import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../Kleague/kLeague.dart';

import 'ChatData.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OFFSIDE",
      routes: {"/": (context) => Community()},
    );
  }
}

class Community extends StatelessWidget {
  const Community({Key? key}) : super(key: key);
  bool isLoading = false;
  Map<String, DataModel> responseData = Map();

  final List<String> videoIdList = <String>[];

  Future<void> init(String collection) async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection(collection)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        log("id : ${element.data()['id']}");
        log("title : ${element.data()['title']}");
        log("image : ${element.data()['image']}");
        log("view : ${element.data()['view']}");

        if (collection == 'my_youtube') {
          videoIdList.add(element.data()['id']);
          responseData[element.data()['id']] = DataModel(
              title: element.data()['title'],
              thumbnail: element.data()['thumbnail'],
              viewCount: element.data()['viewCount']);
        }
      });
      setState(() {
        isLoading = true;
      });
    });

    @override
    Widget build(BuildContext context) {
      var size = MediaQuery.of(context).size;
      return ListView(
        children: [
          SizedBox(
            child: Top(),
          ),
          Container(
            height: 450,
            child: CommunityChat(),
          )
        ],
      );
    }
  }
}
