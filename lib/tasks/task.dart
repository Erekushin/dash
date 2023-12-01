import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../boxes/boxcont.dart';
import 'task_cont.dart';
import '../helpers/time.dart';
import '../widgets/buttons.dart';
import '../widgets/widget_tools.dart';

// ignore: must_be_immutable
class Task extends StatefulWidget {
  Task(
      {super.key,
      required this.item,
      required this.id,
      required this.selectedLabelid,
      required this.selectedLabelname});
  final item;
  final String id;
  String selectedLabelname;
  String
   selectedLabelid;
  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final cont = Get.find<TaskCont>();
  final boxCont = Get.find<BoxCont>();

  TimeHelper timeHelper = TimeHelper();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Set this to true
        backgroundColor: Colors.black.withOpacity(.8),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 80,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.only(
                    left: 40, right: 40, top: 5, bottom: 5),
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: cont.txtCnt,
                  maxLines: null, // Set maxLines to null for multiline support
                  decoration: const InputDecoration(
                    hintText: 'new task... ',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 120,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.only(
                    left: 40, right: 40, top: 5, bottom: 5),
                padding: const EdgeInsets.all(10),
                child: const TextField(
                  maxLines: null, // Set maxLines to null for multiline support
                  decoration: InputDecoration(
                    hintText: 'description... ',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.only(
                    left: 40, right: 40, top: 5, bottom: 5),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        taskProperty(
                            'starting date',
                            TextField(
                              enabled: false,
                              onTap: () {},
                              textAlign: TextAlign.center,
                              controller: cont.startingDate,
                            ), () async {
                          String incomingValue =
                              await timeHelper.selectDate(context);
                          if (incomingValue.isNotEmpty) {
                            cont.startingDate.text = incomingValue;
                          }
                        }),
                        taskProperty(
                            'starting time',
                            TextField(
                              enabled: false,
                              onTap: () {},
                              textAlign: TextAlign.center,
                              controller: cont.startingTime,
                            ), () async {
                          String incomingValue =
                              await timeHelper.selectTime(context);
                          if (incomingValue.isNotEmpty) {
                            cont.startingTime.text = incomingValue;
                          }
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        taskProperty(
                            'pinned date',
                            TextField(
                              enabled: false,
                              onTap: () {},
                              textAlign: TextAlign.center,
                              controller: cont.pinnedDate,
                            ), () async {
                          String incomingValue =
                              await timeHelper.selectDate(context);
                          if (incomingValue.isNotEmpty) {
                            cont.pinnedDate.text = incomingValue;
                          }
                        }),
                        taskProperty(
                            'pinned time',
                            TextField(
                              enabled: false,
                              onTap: () {},
                              textAlign: TextAlign.center,
                              controller: cont.pinnedTime,
                            ), () async {
                          String incomingValue =
                              await timeHelper.selectTime(context);
                          if (incomingValue.isNotEmpty) {
                            cont.pinnedTime.text = incomingValue;
                          }
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        taskProperty(
                            'importancy',
                            TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              onTap: () {},
                              textAlign: TextAlign.center,
                              controller: cont.importancy,
                            ),
                            () {}),
                        taskProperty(
                            'label',
                            Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: InkWell(
                                      onTap: () {
                                        // builtInDropDown(context);
                                        Get.defaultDialog(
                                            title: '',
                                            content: SizedBox(
                                              width: 200,
                                              height: 200,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      boxCont.boxList.length,
                                                  itemBuilder: (c, i) {
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          widget.selectedLabelname = cont.boxName = 
                                                              boxCont.boxList[i]
                                                                  ['boxname'];
                                                        });
                                                            cont.boxId = boxCont.entryNames[i]; 
                                                        Get.back();
                                                      },
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration: const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                              color:
                                                                  Colors.black),
                                                          child: Text(
                                                            boxCont.boxList[i]
                                                                ['boxname'],
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          )),
                                                    );
                                                  }),
                                            ));
                                      },
                                      child: Center(
                                          child:
                                              Text(widget.selectedLabelname))),
                                )),
                            () {})
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text('Duration  '),
                        Text(widget.item['spending_time'].toString()),
                        const Text('  hours')
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text('Remaining  '),
                        Text(widget.item['remaininghours'].toString()),
                        const Text('  hours'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        standartBtn('save new values', () {
                          cont.updatedTime = GlobalValues.nowStr;
                          cont.updateTask(widget.id);
                        }),
                        const SizedBox(width: 5),
                        standartBtn('Nailed It', () {
                          cont.doneIt = 1;
                          cont.finishedTime = GlobalValues.nowStrShort;
                          cont.updateTask(widget.id);
                        }),
                        IconButton(
                            onPressed: () {
                              cont.deleteTask(widget.id);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                              size: 30,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
