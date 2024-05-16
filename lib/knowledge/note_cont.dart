import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';
import '../idea_stream/idea_stream_cont.dart';
import '../widgets/snacks.dart';

class NoteCont extends GetxController {
  //#region label CRUD---------------------------------------------------
  createLabel() async {
    try {
      if (labeltxt.text.isNotEmpty) {
        String id = StaticHelpers.id;
        StaticHelpers.databaseReference
            .child('$labelpath/$id')
            .set(labelProperties(id))
            .whenComplete(() {
          readLabels();
          labeltxt.clear();
        });
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  readLabels() async {
    try {
      DatabaseEvent a =
          await StaticHelpers.databaseReference.child(labelpath).once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        labelList.value = data.values.toList();
        labelIds = data.keys.toList();
        chosenLabel.value = labelList[0]['label'];
      } else {
        labelList.clear();
        labelIds.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  updateLabel(String id) async {
    try {
      StaticHelpers.databaseReference
          .child('$labelpath/$id')
          .set(labelProperties(id))
          .whenComplete(() {
        readLabels();
        labeltxt.clear();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deleteLabel(String id) async {
    try {
      StaticHelpers.databaseReference
          .child('$labelpath/$id')
          .remove()
          .then((_) {
        readLabels();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  //#endregion-----------------------------------------------------------
  //---------------------------------------------------------------------
  //#region Note CRUD----------------------------------------------------

  createNote(bool movingIn, bool isUpdate) async {
    try {
      if (notetxt.text.isNotEmpty) {
        if (!isUpdate) {
          noteId = StaticHelpers.id;
        }
        StaticHelpers.databaseReference
            .child('$path/$noteId')
            .set(noteProperties())
            .whenComplete(() {
          Snacks.savedSnack();
          notetxt.clear();
          noteTitle.clear();
        });
      }
      if (movingIn) {
        ideaCont.deleteIdea(GlobalValues.movingIncomingIdeaId!);
      }
      readNotes();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  readNotes() async {
    try {
      Query b = StaticHelpers.databaseReference
          .child(path)
          .orderByChild('label')
          .equalTo(chosenLabel.value);
      DatabaseEvent a = await b.once();
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

  updateNote() async {}

  deleteNote(String id) async {
    try {
      StaticHelpers.databaseReference.child('$path/$id').remove().then((_) {
        Snacks.deleteSnack();
        readNotes();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  //#endregion-----------------------------------------------------------
  //---------------------------------------------------------------------
  //#region helpers------------------------------------------------------

  setValues(item) {
    noteId = item['id'];
    noteTitle.text = item['title'];
    notetxt.text = item['note'];
  }

  getToday(String theday) async {
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

  Map<String, dynamic> noteProperties() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = noteId;
    data['note'] = notetxt.text;
    data['title'] = noteTitle.text;
    data['label'] = chosenLabel.value;
    data['created_time'] = GlobalValues.nowStrShort;
    return data;
  }

  Map<String, dynamic> labelProperties(String id) {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = labeltxt.text;
    data['created_time'] = GlobalValues.nowStrShort;
    data['updated_time'] = GlobalValues.nowStr;
    return data;
  }

  //#endregion-----------------------------------------------------------
  //---------------------------------------------------------------------
  //#region variebles----------------------------------------------------

  final ideaCont = Get.find<IdeaStreamCont>();

  TextEditingController searchTxt = TextEditingController();
  TextEditingController labeltxt = TextEditingController();
  //#region note properties
  String noteId = '';

  TextEditingController noteTitle = TextEditingController();

  TextEditingController notetxt = TextEditingController();

  RxString chosenLabel = ''.obs;
  //#endregion
  RxList notes = [].obs;
  List entryNames = [];
  List<bool> expandedbool = <bool>[];
  String path = '';
  RxList labelList = [].obs;
  List labelIds = [];

  String labelpath = '';

  RxList noteoftheday = [].obs;

  //#endregion---------------------------------------------------------
}
