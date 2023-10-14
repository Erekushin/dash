import 'package:erek_dash/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/snacks.dart';

class IdeaStreamCont extends GetxController {
  Map<String, dynamic> streamIdeaValues() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['incoming_idea'] = ideaTxtCnt.text;
    return data;
  }

  String path = 'streamOfIdeas';
  RxList ideaList = [].obs;
  List entryNames = [];
  Future<dynamic> getAllNewIdeas() async {
    try {
      DatabaseEvent a =
          await StaticHelpers.databaseReference.child(path).once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        entryNames = data.keys.toList();
        ideaList.value = data.values.toList();
      } else {
        ideaList.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  TextEditingController ideaTxtCnt = TextEditingController();
  String firstValue = '';

  Future insertIdea() async {
    if (ideaTxtCnt.text.isNotEmpty) {
      try {
        StaticHelpers.databaseReference
            .child('$path/${StaticHelpers.id}')
            .set(streamIdeaValues())
            .whenComplete(() {
          Snacks.savedSnack();
          ideaTxtCnt.clear();
          getAllNewIdeas();
        });
      } catch (e) {
        Snacks.errorSnack(e);
      }
    }
  }

  Future updateNewIdea(int id) async {
    ideaTxtCnt.text = ideaTxtCnt.text.trimRight();
    if (firstValue != ideaTxtCnt.text) {
      try {
        StaticHelpers.databaseReference
            .child('$path/$id')
            .set(streamIdeaValues())
            .whenComplete(() {
          Snacks.savedSnack();
          ideaTxtCnt.clear();
          getAllNewIdeas();
        });
      } catch (e) {
        Snacks.errorSnack(e);
      }
    }
  }

  Future deleteIdea(int id) async {
    try {
      StaticHelpers.databaseReference.child("$path/$id").remove().then((_) {
        getAllNewIdeas();
        Get.back();
        Snacks.deleteSnack();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
