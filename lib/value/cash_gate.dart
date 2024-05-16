import 'package:erek_dash/tasks/task_cont.dart';
import 'package:erek_dash/value/value_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/time.dart';
import '../widgets/widget_tools.dart';

Object cashGate(BuildContext conte, bool edit, var item) {
  var valCont = Get.find<ValueCont>();
  var taskCont = Get.find<TaskCont>();
  TimeHelper timeHelper = TimeHelper();
  Color cashBoxColor = Colors.white;
  double cashboxRadius = 0;
  String incomingDateValue = '';
  String incomingTimeValue = '';
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
                if (incomingDateValue == '' && incomingTimeValue == '') {
                  valCont.createValue();
                } else {
                  taskCont.txtCnt = valCont.txtCnt;
                  taskCont.descriptionTxt = valCont.descriptionTxt;
                  taskCont.createValue();
                }

                Navigator.of(conte).pop();
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true, // Set this to true
                backgroundColor: Colors.black.withOpacity(.8),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
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
                              controller: valCont.txtCnt,
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
                                    taskCont.isActive = true;
                                    valCont.isActive = true;
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
                                    taskCont.isActive = false;
                                    valCont.isActive = false;
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
                          TextField(
                            controller: valCont.descriptionTxt,
                            decoration:
                                const InputDecoration(hintText: "Тайлбар"),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Row(children: [
                              taskProperty(
                                  'pinned date',
                                  TextField(
                                    enabled: false,
                                    onTap: () {},
                                    textAlign: TextAlign.center,
                                    controller: taskCont.pinnedDate,
                                  ), () async {
                                incomingDateValue =
                                    await timeHelper.selectDate(conte);
                                if (incomingDateValue.isNotEmpty) {
                                  taskCont.startingDate.text = taskCont
                                      .pinnedDate.text = incomingDateValue;
                                }
                              }),
                              taskProperty(
                                  'pinned time',
                                  TextField(
                                    enabled: false,
                                    textAlign: TextAlign.center,
                                    controller: taskCont.pinnedTime,
                                  ), () async {
                                incomingTimeValue =
                                    await timeHelper.selectTime(conte);
                                if (incomingTimeValue.isNotEmpty) {
                                  taskCont.startingTime.text = taskCont
                                      .pinnedTime.text = incomingTimeValue;
                                }
                              })
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: edit,
                      child: Container(
                        margin: const EdgeInsets.only(left: 40, right: 40),
                        width: double.infinity,
                        height: 50,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                )),
                            IconButton(
                                onPressed: () {
                                  if (item['pinned_time'] == '' ||
                                      item['pinned_time'] == null) {
                                    valCont.deleteValue(item['id']);
                                  } else {
                                    taskCont.deleteValue(item['id']);
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

//cash gate ee neene utguudaa oruulna pinned time ee songoh yum bol task deer task nemegdej bgaagaar nemegdene songohgvi bol values deer nemegdene

//home iin value btn deer darah vyd task uud dundaasaa filter deed avchih ni value history ruu oroh yum bol value gesen path aar datagaa duudaj avchirna

//value deer discription oruuldag heseg oruulaad discription ee harah bolomjtoi bolchihvol yadaj l yamar2 zardal gargasanaa haraad baih bolomjtoi bolnoo geseb vg

//tseshlaad tailan gargadag bolgochih heregtei
