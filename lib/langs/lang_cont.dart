import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';
import '../widgets/snacks.dart';

class LangCont extends GetxController {
  RxList langList = [].obs;
  List entryNames = [];
  TextEditingController langtxt = TextEditingController();
  String path = '';

  Future allLangs() async {
    try {
      DatabaseEvent a =
          await StaticHelpers.databaseReference.child(path).once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        langList.value = data.values.toList();
        entryNames = data.keys.toList();
      } else {
        langList.clear();
        entryNames.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  Map<String, dynamic> langValues() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['lang'] = langtxt.text;
    data['created_time'] = GlobalValues.nowStrShort;
    data['updated_time'] = GlobalValues.nowStr;
    return data;
  }

  insertlang() async {
    try {
      if (langtxt.text.isNotEmpty) {
        StaticHelpers.databaseReference
            .child('$path/${StaticHelpers.id}')
            .set(langValues())
            .whenComplete(() {
          allLangs();
          langtxt.clear();
        });
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  updatelang(String id) async {
    try {
      StaticHelpers.databaseReference
          .child('$path/$id')
          .set(langValues())
          .whenComplete(() {
        allLangs();
        langtxt.clear();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deletelang(String id) async {
    try {
      StaticHelpers.databaseReference.child('$path/$id').remove().then((_) {
        allLangs();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  RxList wordList = [].obs;
  List wordentryNames = [];
  TextEditingController wordtxt = TextEditingController();
  TextEditingController translationtxt = TextEditingController();
  int level = 0;
  String chosenLang = '';
  String chosenLangId = '';
  int searchLevel = 0;
  Future alllangwords() async {
    try {
      Query b = StaticHelpers.databaseReference
          .child('$path/$chosenLangId/words/')
          .orderByChild('level')
          .equalTo(searchLevel);
      DatabaseEvent a = await b.once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        wordList.value = data.values.toList();
        wordentryNames = data.keys.toList();
        print('$searchLevel ------ ${data.values}');
      } else {
        wordList.clear();
        wordentryNames.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  Map<String, dynamic> wordValues() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['word'] = wordtxt.text;
    data['translation'] = translationtxt.text;
    data['level'] = level;
    data['lang_name'] = chosenLang;
    data['created_time'] = GlobalValues.nowStrShort;
    data['updated_time'] = GlobalValues.nowStr;
    return data;
  }

  void clearFields() {
    wordtxt.clear();
    translationtxt.clear();
    level = 0;
  }

  insertword() async {
    try {
      if (wordtxt.text.isNotEmpty) {
        StaticHelpers.databaseReference
            .child('$path/$chosenLangId/words/${StaticHelpers.id}')
            .set(wordValues())
            .whenComplete(() {
          alllangwords();
        });
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  updateword(String id) async {
    try {
      StaticHelpers.databaseReference
          .child('$path/$chosenLangId/words/$id')
          .set(wordValues())
          .whenComplete(() {
        alllangwords();
        clearFields();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deleteword(String id) async {
    try {
      StaticHelpers.databaseReference
          .child('$path/$chosenLangId/words/$id')
          .remove()
          .then((_) {
        alllangwords();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
