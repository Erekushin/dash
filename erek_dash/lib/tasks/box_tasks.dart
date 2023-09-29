import 'package:erek_dash/tasks/task_edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'task_cont.dart';
import '../helpers/time.dart';

class BoxTask extends StatefulWidget {
  const BoxTask({super.key});

  @override
  State<BoxTask> createState() => _BoxTaskState();
}

class _BoxTaskState extends State<BoxTask> {
  TimeHelper timeHelper = TimeHelper();
  final cont = Get.find<TaskCont>();

  @override
  Widget build(BuildContext context) {
    return GetX<TaskCont>(
      builder: (littleCont) {
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3, // littleCont.boxTasks.value.taskList.length,
            shrinkWrap: true,
            itemBuilder: (c, index) {
              var item; // = littleCont.boxTasks.value.taskList[index];
              return InkWell(
                onTap: () {
                  littleCont.txtCnt.text = item.txt!;
                  littleCont.startingDate.text = item.startingTime ??
                      item.startingTime.toString().substring(0, 10);
                  littleCont.startingTime.text = item.startingTime ??
                      item.startingTime.toString().substring(11, 16);
                  littleCont.pinnedDate.text = item.pinnedTime ??
                      item.pinnedTime.toString().substring(0, 10);
                  littleCont.pinnedTime.text = item.pinnedTime ??
                      item.pinnedTime.toString().substring(11, 16);
                  littleCont.importancy.text = item.importancy.toString();
                  Get.to(() => TaskEdit(
                        item: item,
                        id: cont.entryNames[index],
                        selectedLabelid: item.label!,
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
