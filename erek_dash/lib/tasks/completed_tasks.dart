import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'task_cont.dart';
import '../globals.dart';
import '../widgets/buttons.dart';

class CompletedTasks extends StatefulWidget {
  const CompletedTasks({super.key});

  @override
  State<CompletedTasks> createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {
  final cont = Get.find<TaskCont>();
  late String chosenId;
  RxBool editVis = false.obs;
  @override
  void initState() {
    cont.getAllCompleted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<TaskCont>(builder: (littleCont) {
      return Scaffold(
        backgroundColor: MyColors.mainColor,
        appBar: AppBar(
          title: Text(
            'complited task: ${littleCont.completedList.length}',
            style: const TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: littleCont.completedList.length,
                    itemBuilder: (c, i) {
                      var item = littleCont.completedList[i];
                      return InkWell(
                        onLongPress: () {
                          littleCont.setValues(item);
                          chosenId = littleCont.completedEntryNames[i];
                          editVis.value = true;
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item['task'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    item['finished_time']
                                        .toString()
                                        .substring(0, 10),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ]),
                        ),
                      );
                    }),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Obx(() => Visibility(
                    visible: editVis.value,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            standartBtn('undo it', () {
                              littleCont.doneIt = 0;
                              littleCont.finishedTime = "";
                              littleCont.updateTask(chosenId);
                            }),
                            IconButton(
                                onPressed: () {
                                  littleCont.deleteTask(chosenId);
                                  littleCont.getAllCompleted();
                                  editVis.value = false;
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                )),
                            IconButton(
                                onPressed: () {
                                  editVis.value = false;
                                },
                                icon: const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.black,
                                )),
                          ]),
                    ))),
              )
            ],
          ),
        ),
      );
    });
  }
}
