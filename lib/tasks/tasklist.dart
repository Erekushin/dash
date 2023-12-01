import 'package:erek_dash/globals.dart';
import 'package:erek_dash/tasks/task.dart';
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
              var item = littleCont.taskList[index]['value'];
              return InkWell(
                onTap: () {
                  littleCont.setValues(item);

                  Get.to(() => Task(
                        item: item,
                        id: cont.taskList[index]['id'],
                        selectedLabelid: item['boxId'] ?? 0,
                        selectedLabelname: item['boxname'] ?? '',
                      ));
                },
                child: item['boxId'] == "value"
                    ? Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 5),
                        alignment: Alignment.centerLeft,
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            color: item['active']
                                ? Colors.green
                                : const Color.fromARGB(255, 202, 29, 17),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        child: Row(children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item['active']
                                    ? Colors.greenAccent
                                    : Colors.redAccent),
                            child: Icon(
                              item['active']
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '${item['task']}₮',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                              item['pinned_time'].toString().substring(2, 10),
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ]),
                      )
                    : Container(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 20, right: 5),
                        alignment: Alignment.centerLeft,
                        width: 300,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 260,
                              child: Text(
                                item['task'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.black,
                              ),
                              child: Text(
                                item['timeValue'].toString(),
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
