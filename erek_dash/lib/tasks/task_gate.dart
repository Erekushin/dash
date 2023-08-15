import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../boxes/boxcont.dart';
import '../helpers/time.dart';
import '../widgets/widget_tools.dart';
import 'task_cont.dart';

class TaskGate extends StatefulWidget {
  TaskGate({super.key, required this.incomingIsMoving});
  bool incomingIsMoving;
  @override
  State<TaskGate> createState() => _TaskGateState();
}

class _TaskGateState extends State<TaskGate> {
  final cont = Get.find<TaskCont>();
  final boxCont = Get.find<BoxCont>();
  TimeHelper timeHelper = TimeHelper();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        cont.insertTask(widget.incomingIsMoving);
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
              margin:
                  const EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 5),
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
              margin:
                  const EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 5),
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
              margin:
                  const EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 5),
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
                            textAlign: TextAlign.center,
                            controller: cont.startingTime,
                          ), () async {
                        String incomingValue =
                            await timeHelper.selectTime(context);
                        if (incomingValue.isNotEmpty) {
                          cont.startingTime.text = incomingValue;
                        }
                      })
                    ],
                  ),
                  Row(
                    children: [
                      taskProperty(
                          'pinned time',
                          TextField(
                            enabled: false,
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
                            textAlign: TextAlign.center,
                            controller: cont.importancy,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
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
                                                        cont.selectedLabelname =
                                                            boxCont.boxList[i]
                                                                ['boxname'];
                                                      });
                                                      cont.selectedLabelid =
                                                          boxCont.boxList[i]
                                                              ['id'];
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        margin: const EdgeInsets
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
                                        child: Text(cont.selectedLabelname))),
                              )),
                          () {})
                    ],
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
