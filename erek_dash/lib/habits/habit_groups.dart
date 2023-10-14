import 'package:erek_dash/globals.dart';
import 'package:erek_dash/tasks/task_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/time.dart';
import '../widgets/snacks.dart';
import '../widgets/widget_tools.dart';
import 'habit_cont.dart';
import 'habit_list.dart';

class HabitGroups extends StatefulWidget {
  const HabitGroups({super.key});

  @override
  State<HabitGroups> createState() => _HabitGroupsState();
}

class _HabitGroupsState extends State<HabitGroups> {
  final cont = Get.find<HabitCont>();
  final taskCont = Get.find<TaskCont>();
  bool editvisible = false;

  @override
  void initState() {
    cont.allGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        title: const Text('HabitGroups'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(children: [
          GetX<HabitCont>(builder: (littleCont) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: littleCont.groupList.length,
                itemBuilder: (c, i) {
                  return InkWell(
                      onTap: () {
                        littleCont.chosenGroupId = littleCont.groupEntries[i];

                        Get.to(() => const Habits());
                      },
                      onLongPress: () {
                        littleCont.chosenGroupId = littleCont.groupEntries[i];
                        cont.groupTxt.text = littleCont.groupList[i]['name'];
                        setState(() {
                          editvisible = true;
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.white, width: 1))),
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              littleCont.groupList[i]['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Icon(
                              Icons.arrow_right,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ));
                });
          }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                    visible: editvisible,
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: Colors.black)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                await cont.getAllHabits();
                                cont.packagedList.clear();
                                for (int i = 0;
                                    i < cont.habitList.length;
                                    i++) {
                                  cont.packagedList.add(CurrentHabit(
                                      cont.habitList[i], 0, false));
                                }

                                taskCont.homeMiddleAreaType.value =
                                    'packagedHabits';

                                Get.back();
                                Get.back();
                                Snacks.freeSnack(cont.groupTxt.text);
                              },
                              child: const Icon(
                                Icons.adjust_sharp,
                                color: Colors.blueAccent,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 165,
                              child: TextField(
                                controller: cont.groupTxt,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                cont.updateGroup(cont.chosenGroupId);
                                setState(() {
                                  editvisible = false;
                                });
                              },
                              child: const Icon(
                                Icons.update,
                                color: Colors.blueAccent,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                cont.deleteGroup(cont.chosenGroupId);
                                setState(() {
                                  editvisible = false;
                                });
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30,
                              ),
                            )
                          ]),
                    )),
                InkWell(
                  onTap: () {
                    habitGroupGate(context, cont.groupTxt, () {
                      cont.insertGroup();
                      Navigator.of(context).pop();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Colors.black)),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}

Object habitGroupGate(
    BuildContext conte, TextEditingController txtCont, Function func) {
  bool isPerminant = false;
  TimeHelper timeHelper = TimeHelper();
  final cont = Get.find<HabitCont>();
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
                func();
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true, // Set this to true
                backgroundColor: Colors.black.withOpacity(.8),
                body: Center(
                  child: SizedBox(
                    width: 350,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 80,
                          child: Card(
                            color: Colors.white,
                            shadowColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                controller: txtCont,
                                maxLines:
                                    null, // Set maxLines to null for multiline support
                                decoration: const InputDecoration(
                                    hintText: 'group name',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          child: Card(
                            color: Colors.white,
                            shadowColor: Colors.transparent,
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      onChanged: (v) {
                                        setstate(() {
                                          {
                                            isPerminant = !isPerminant;
                                          }
                                        });
                                      },
                                      value: isPerminant,
                                    ),
                                    const Text('Is perminant?')
                                  ],
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 110,
                          child: Card(
                            color: Colors.white,
                            shadowColor: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  taskProperty(
                                      'choose date',
                                      TextField(
                                        enabled: false,
                                        textAlign: TextAlign.center,
                                        controller: cont.chosenDate,
                                      ), () async {
                                    String incomingValue =
                                        await timeHelper.selectDate(conte);
                                    if (incomingValue.isNotEmpty) {
                                      cont.chosenDate.text = incomingValue;
                                    }
                                  }),
                                  taskProperty(
                                      'choose time',
                                      TextField(
                                        enabled: false,
                                        textAlign: TextAlign.center,
                                        controller: cont.chosenTime,
                                      ), () async {
                                    String incomingValue =
                                        await timeHelper.selectTime(conte);
                                    if (incomingValue.isNotEmpty) {
                                      cont.chosenTime.text = incomingValue;
                                    }
                                  })
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
