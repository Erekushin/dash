import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/work_with_database.dart';
import '../widgets/snacks.dart';

class IdeaStreamCont extends GetxController {
  String tableName = 'idea_stream';
  WorkLocal workLocalCont = WorkLocal();
  RxList ideaList = [].obs;
  Future<dynamic> getAllNewIdeas() async {
    ideaList.value = await workLocalCont.fetchData(tableName);
  }

  TextEditingController ideaTxtCnt = TextEditingController();
  TextEditingController ideaEditorCont = TextEditingController();
  String firstValue = '';

  void insertIdea() {
    if (ideaTxtCnt.text.isNotEmpty) {
      try {
        workLocalCont.insertData(tableName, {'incoming_idea': ideaTxtCnt.text});
        Snacks.savedSnack();
        ideaTxtCnt.clear();
        getAllNewIdeas();
      } catch (e) {
        Snacks.errorSnack(e);
      }
    }
  }

  void updateNewIdea(int id) {
    print(ideaEditorCont.text.length);
    ideaEditorCont.text = ideaEditorCont.text.trimRight();
    print(ideaEditorCont.text.length);
    if (firstValue != ideaEditorCont.text) {
      workLocalCont
          .updateData(tableName, id, {'incoming_idea': ideaEditorCont.text});
      getAllNewIdeas();
    }
  }

  void deleteIdea(int id) {
    try {
      workLocalCont.deleteData(tableName, 'id', id);
      getAllNewIdeas();
      Get.back();
      Snacks.deleteSnack();
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }
}
