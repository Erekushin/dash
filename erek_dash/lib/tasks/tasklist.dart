import 'package:erek_dash/tasks/task_edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'task_cont.dart';
import '../helpers/time.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TimeHelper timeHelper = TimeHelper();
  final cont = Get.find<TaskCont>();
  @override
  void initState() {
    cont.getAllTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<TaskCont>(
      builder: (littleCont) {
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: littleCont.taskList.length,
            shrinkWrap: true,
            itemBuilder: (c, index) {
              var item = littleCont.taskList[index];
              return InkWell(
                onTap: () {
                  littleCont.editCnt.text = item.txt!;
                  littleCont.editstartingDate.text = item.startingTime ??
                      item.startingTime.toString().substring(0, 10);
                  littleCont.editstartingTime.text = item.startingTime ??
                      item.startingTime.toString().substring(11, 16);
                  littleCont.editpinnedDate.text = item.pinnedTime ??
                      item.pinnedTime.toString().substring(0, 10);
                  littleCont.editpinnedTime.text = item.pinnedTime ??
                      item.pinnedTime.toString().substring(11, 16);
                  littleCont.editimportancy.text = item.importancy.toString();

                  Get.to(() => TaskEdit(
                        item: item,
                        selectedLabelid: item.label ?? 0,
                        selectedLabelname: item.labelname ?? '',
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 20, right: 5),
                  alignment: Alignment.centerLeft,
                  width: 300,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 260,
                        child: Text(
                          item.txt!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.black,
                        ),
                        child: Text(
                          item.timeValue?.toString() ?? '0',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
