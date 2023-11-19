import 'package:erek_dash/globals.dart';
import 'package:erek_dash/tasks/task_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/time.dart';
import '../widget_tools.dart';

Object cashGate(BuildContext conte) {
  var cont = Get.find<TaskCont>();
  TimeHelper timeHelper = TimeHelper();
  Color cashBoxColor = Colors.white;
  double cashboxRadius = 0;
  return showGeneralDialog(
    context: conte,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(conte).modalBarrierDismissLabel,
    barrierColor: const Color.fromARGB(133, 0, 0, 0),
    pageBuilder: (conte, anim1, anim2) {
      return StatefulBuilder(
        builder: (conte, setstate) {
          return SafeArea(
            child: GestureDetector(
              onTap: () {
                cont.boxId = 'value';
                cont.startingDate.text = cont.pinnedDate.text;
                cont.startingTime.text = cont.pinnedTime.text;
                cont.insertTask(false);
                Navigator.of(conte).pop();
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true, // Set this to true
                backgroundColor: Colors.black.withOpacity(.8),
                body: Center(
                    child: AnimatedContainer(
                  margin: const EdgeInsets.only(
                      left: 40, right: 40, top: 5, bottom: 5),
                  duration: const Duration(seconds: 1),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: cashBoxColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(cashboxRadius))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: cont.txtCnt,
                          maxLines:
                              null, // Set maxLines to null for multiline support
                          decoration: const InputDecoration(
                            hintText: 'value. . . ',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap: () {
                                cont.isActive = true;
                                setstate(() {
                                  cashboxRadius = 15;
                                  cashBoxColor = Colors.green;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                    color: Colors.greenAccent,
                                    shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.arrow_downward_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              )),
                          InkWell(
                              onTap: () {
                                cont.isActive = false;
                                setstate(() {
                                  cashboxRadius = 15;
                                  cashBoxColor = Colors.red;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.arrow_upward_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(children: [
                          taskProperty(
                              'pinned date',
                              TextField(
                                enabled: false,
                                onTap: () {},
                                textAlign: TextAlign.center,
                                controller: cont.pinnedDate,
                              ), () async {
                            String incomingValue =
                                await timeHelper.selectDate(conte);
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
                                await timeHelper.selectTime(conte);
                            if (incomingValue.isNotEmpty) {
                              cont.pinnedTime.text = incomingValue;
                            }
                          })
                        ]),
                      ),
                    ],
                  ),
                )),
              ),
            ),
          );
        },
      );
    },
  );
}
