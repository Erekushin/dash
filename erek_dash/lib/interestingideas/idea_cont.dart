import 'package:erek_dash/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/snacks.dart';

class IdeaCont extends GetxController {
  String path = 'newIdeas';

  RxList interestingIdeaList = [].obs;
  List entryNames = [];
  Future allIdeas() async {
    try {
      DatabaseEvent a =
          await StaticHelpers.databaseReference.child(path).once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        interestingIdeaList.value = data.values.toList();
        entryNames = data.keys.toList();
      } else {
        interestingIdeaList.clear();
        entryNames.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  Map<String, dynamic> ideaValues() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['idea'] = ideaTxt.text;
    data['created_time'] = GlobalValues.nowStrShort;
    data['updated_time'] = GlobalValues.nowStr;
    return data;
  }

  TextEditingController ideaTxt = TextEditingController();
  insertIdea() async {
    try {
      if (ideaTxt.text.isNotEmpty) {
        StaticHelpers.databaseReference
            .child('$path/${StaticHelpers.id}')
            .set(ideaValues())
            .whenComplete(() {
          allIdeas();
          ideaTxt.clear();
        });
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  updateIdea(String id) async {
    try {
      StaticHelpers.databaseReference
          .child('$path/$id')
          .set(ideaValues())
          .whenComplete(() {
        allIdeas();
        ideaTxt.clear();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deleteIdea(String id) async {
    try {
      StaticHelpers.databaseReference.child('$path/$id').remove().then((_) {
        allIdeas();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
