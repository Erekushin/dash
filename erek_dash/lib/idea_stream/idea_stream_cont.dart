import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/snacks.dart';

class IdeaStreamCont extends GetxController {
  String tableName = 'idea_stream';
  RxList ideaList = [].obs;
  Future<dynamic> getAllNewIdeas() async {
    try {
      final db = await Erekdatabase.database;
      ideaList.value = await db.query(tableName);
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  TextEditingController ideaTxtCnt = TextEditingController();
  TextEditingController ideaEditorCont = TextEditingController();
  String firstValue = '';

  Future insertIdea() async {
    if (ideaTxtCnt.text.isNotEmpty) {
      try {
        final db = await Erekdatabase.database;
        db.insert(tableName, {'incoming_idea': ideaTxtCnt.text});
        Snacks.savedSnack();
        ideaTxtCnt.clear();
        getAllNewIdeas();
      } catch (e) {
        Snacks.errorSnack(e);
      }
    }
  }

  Future updateNewIdea(int id) async {
    print(ideaEditorCont.text.length);
    ideaEditorCont.text = ideaEditorCont.text.trimRight();
    print(ideaEditorCont.text.length);
    if (firstValue != ideaEditorCont.text) {
      try {
        final db = await Erekdatabase.database;
        db.update(tableName, {'incoming_idea': ideaEditorCont.text},
            where: 'id = $id');

        getAllNewIdeas();
      } catch (e) {
        Snacks.errorSnack(e);
      }
    }
  }

  Future deleteIdea(int id) async {
    try {
      final db = await Erekdatabase.database;
      db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      getAllNewIdeas();
      Get.back();
      Snacks.deleteSnack();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
