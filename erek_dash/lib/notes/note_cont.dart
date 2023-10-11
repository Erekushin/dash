import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';
import '../idea_stream/idea_stream_cont.dart';
import '../widgets/snacks.dart';

class NoteCont extends GetxController {
  final ideaCont = Get.find<IdeaStreamCont>();
  RxList notes = [].obs;
  List entryNames = [];
  List<bool> expandedbool = <bool>[];
  String path = 'notes';
  Future getAll() async {
    try {
      DatabaseEvent a =
          await StaticHelpers.databaseReference.child(path).once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        notes.value = data.values.toList();
        entryNames = data.keys.toList();
      } else {
        notes.clear();
        entryNames.clear();
      }
      for (int i = 0; i < notes.length; i++) {
        expandedbool.add(false);
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  RxList noteoftheday = [].obs;
  Future getToday(String theday) async {
    try {
      Query b = StaticHelpers.databaseReference
          .child(path)
          .orderByChild('created_time')
          .equalTo(
            theday,
          );

      DatabaseEvent a = await b.once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        noteoftheday.value = data.values.toList();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  Map<String, dynamic> noteValues() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['note'] = notetxt.text;
    data['title'] = noteTitle.text;
    data['created_time'] = GlobalValues.nowStrShort;
    return data;
  }

  TextEditingController notetxt = TextEditingController();
  TextEditingController noteTitle = TextEditingController();
  Future insertNote(bool movingIn) async {
    try {
      if (notetxt.text.isNotEmpty) {
        StaticHelpers.databaseReference
            .child('$path/${StaticHelpers.id}')
            .set(noteValues())
            .whenComplete(() {
          Snacks.savedSnack();
          notetxt.clear();
          noteTitle.clear();
        });
      }
      if (movingIn) {
        ideaCont.deleteIdea(GlobalValues.movingIncomingIdeaId!);
      }
      getAll();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  Future deleteNote(String id) async {
    try {
      StaticHelpers.databaseReference.child('$path/$id').remove().then((_) {
        getAll();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
