import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../knowledge/note_cont.dart';
import '../globals.dart';
import '../knowledge/note_gate.dart';
import '../tasks/task_cont.dart';
import '../tasks/task_gate.dart';
import 'idea_stream_cont.dart';

class InfoEdit extends StatelessWidget {
  InfoEdit({super.key, required this.id});
  final int id;
  final cont = Get.find<IdeaStreamCont>();
  final noteCont = Get.find<NoteCont>();
  final taskCont = Get.find<TaskCont>();
  RxString mainFunctionalityType = 'incoming'.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        cont.updateNewIdea(id);
        Get.back();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Set this to true
        backgroundColor: Colors.black.withOpacity(.8),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            height: 600,
            child: Card(
              color: Colors.white,
              shadowColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 8,
                      child: TextField(
                        controller: cont.ideaTxtCnt,
                        maxLines:
                            null, // Set maxLines to null for multiline support
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black)),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Obx(() => Container(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Colors.black,
                                  ),
                                  margin: const EdgeInsets.all(5),
                                  child: DropdownButton<String>(
                                    underline: const SizedBox(),
                                    style: const TextStyle(color: Colors.white),
                                    value: mainFunctionalityType.value,
                                    items: [
                                      for (var item
                                          in GlobalStatics.mainFunctionalities)
                                        DropdownMenuItem(
                                          value: item['name'],
                                          child: Text(
                                            item['name'],
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ),
                                    ],
                                    onChanged: (value) {
                                      mainFunctionalityType.value = value!;
                                      GlobalValues.movingIncomingIdeaId = id;
                                      switch (value) {
                                        case 'note':
                                          noteCont.notetxt.text =
                                              cont.ideaTxtCnt.text;
                                          Get.off(() => NoteGate(
                                                incomingIsMoving: true,
                                              ));
                                          break;
                                        case 'task':
                                          taskCont.txtCnt.text =
                                              cont.ideaTxtCnt.text;
                                          var item;
                                          item['initialTaskId'] = "LastTask";
                                          item['step'] = 1;
                                          Get.off(() => TaskGate(
                                                item: item,
                                                incomingIsMoving: true,
                                              ));
                                          break;
                                        default:
                                      }
                                    },
                                    icon: const Padding(
                                      padding: EdgeInsets.only(left: 100),
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.black,
                                ),
                                margin: const EdgeInsets.all(5),
                                child: IconButton(
                                    onPressed: () {
                                      //delete
                                      cont.deleteIdea(id);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 20,
                                    ))),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
