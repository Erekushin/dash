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
  late int chosenId;
  RxBool editVis = false.obs;
  @override
  void initState() {
    cont.getAllCompleted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        title: Text('what I have done'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: GetX<TaskCont>(builder: (littleCont) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: littleCont.completedList.length,
                  itemBuilder: (c, i) {
                    var item = littleCont.completedList[i];
                    return InkWell(
                      onLongPress: () {
                        chosenId = item['id'];
                        editVis.value = true;
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['task'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                item['finished_time'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ]),
                      ),
                    );
                  }),
              const SizedBox(
                height: 50,
              ),
              Text(
                'in total : ${littleCont.completedList.length}',
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
              const Spacer(),
              Obx(() => Visibility(
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
                            littleCont.updateTask(
                                chosenId, {'done_it': 0, 'finished_time': ""});
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
                        ]),
                  )))
            ],
          );
        }),
      ),
    );
  }
}
