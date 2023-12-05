import 'package:erek_dash/globals.dart';
import 'package:erek_dash/tasks/task_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/time.dart';
import '../widgets/snacks.dart';
import '../widgets/widget_tools.dart';

import 'sequence_cont.dart';
import 'progress.dart';

class Sequences extends StatefulWidget {
  const Sequences({super.key});

  @override
  State<Sequences> createState() => _SequencesState();
}

class _SequencesState extends State<Sequences> {
  final cont = Get.find<SequenceCont>();
  final taskCont = Get.find<TaskCont>();
  bool editvisible = false;

  @override
  void initState() {
    cont.readSequenceGroups();
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
          GetX<SequenceCont>(builder: (littleCont) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: littleCont.groupList.length,
                itemBuilder: (c, i) {
                  return InkWell(
                      onTap: () {
                        littleCont.chosenGroupId =
                            littleCont.groupList[i]['id'];
                        Get.to(() => const Seq());
                      },
                      onLongPress: () {
                        littleCont.chosenGroupId =
                            littleCont.groupList[i]['id'];
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
                                await cont.readSequenceItems();

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
                                cont.updateSequenceGroup(cont.chosenGroupId);
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
                                cont.deleteSequenceGroup(cont.chosenGroupId);
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
                    sequenceGroupGate(context, cont.groupTxt, () {
                      cont.createSequenceGroup();
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

Object sequenceGroupGate(
    BuildContext conte, TextEditingController txtCont, Function func) {
  TimeHelper timeHelper = TimeHelper();
  bool isRepeatable = false;
  String type = 'weekly';
  List<int> weekday = [];

  final cont = Get.find<SequenceCont>();

  return showGeneralDialog(
    context: conte,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(conte).modalBarrierDismissLabel,
    barrierColor: const Color.fromARGB(133, 0, 0, 0),
    pageBuilder: (conte, anim1, anim2) {
      return StatefulBuilder(
        builder: (conte, setstate) {
          Widget myRadiobutton(String title, Function func) {
            return Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    InkWell(
                        onTap: () {
                          setstate(() {
                            {
                              func();
                            }
                          });
                        },
                        child: Container(
                          width: 80,
                          height:20,
                          decoration: BoxDecoration(
                              gradient: title == type
                                  ? MyColors.helperPink
                                  : const LinearGradient(colors: [
                                      Colors.white,
                                      Colors.white,
                                    ]),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(width: 1.5)),
                        )),
                        const SizedBox(height: 10),
                    Text(title)
                  ],
                ));
          }

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
                    width: 365,
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
                        Visibility(
                          visible: isRepeatable,
                          child: SizedBox(
                            height: 260,
                            child: Card(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              shadowColor: Colors.transparent,
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          taskProperty(
                                              'start time',
                                              TextField(
                                                enabled: false,
                                                textAlign: TextAlign.center,
                                                controller: cont.chosenTime,
                                              ), () async {
                                            String incomingValue =
                                                await timeHelper
                                                    .selectTime(conte);
                                            if (incomingValue.isNotEmpty) {
                                              cont.chosenTime.text =
                                                  incomingValue;
                                            }
                                          }),
                                          taskProperty(
                                              'finish time',
                                              TextField(
                                                enabled: false,
                                                textAlign: TextAlign.center,
                                                controller: cont.chosenTime,
                                              ), () async {
                                            String incomingValue =
                                                await timeHelper
                                                    .selectTime(conte);
                                            if (incomingValue.isNotEmpty) {
                                              cont.chosenTime.text =
                                                  incomingValue;
                                            }
                                          })
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          myRadiobutton('weekly', () async {
                                            type = 'weekly';
                                          }),
                                          myRadiobutton('monthly', () async{
                                            type = 'monthly';
                                               String incomingValue =
                                                await timeHelper
                                                    .selectDate(conte);
                                          }),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 300,
                                        height: 50,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: 7,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (c, i) {
                                              return InkWell(
                                                onTap: () {
                                                  setstate(() {
                                                    {
                                                      if(weekday.contains(i)){
                                                         weekday.remove(i);
                                                      }else
                                                      {
                                                         weekday.add(i);
                                                      }
                                                     
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      gradient: weekday.contains(i)
                                                          ? MyColors.helperPink
                                                          : const LinearGradient(
                                                              colors: [
                                                                  Colors.white,
                                                                  Colors.white
                                                                ]),
                                                      border: Border.all(
                                                          width: 0.5),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5))),
                                                  width: 30,
                                                  height: 30,
                                                  child:
                                                      Text((i + 1).toString(), style: TextStyle(color: weekday.contains(i)? Colors.white : Colors.black),),
                                                ),
                                              );
                                            }),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: Card(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            shadowColor: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setstate(() {
                                  isRepeatable = !isRepeatable;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                    'is is repeatable? / ${isRepeatable ? "if no" : "is yes"} tap here'),
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

class Seq extends StatefulWidget {
  const Seq({super.key});

  @override
  State<Seq> createState() => _SeqState();
}

class _SeqState extends State<Seq> {
  final cont = Get.find<SequenceCont>();

  @override
  void initState() {
    cont.readSequenceItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        title: const Text('Habits'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: FloatingActionButton(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: Colors.white,
          onPressed: () {
            habitGateWithGroup(context, true, '');
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: GetX<SequenceCont>(
            builder: (littleCont) {
              return ListView.builder(
                  itemCount: littleCont.seqitems.length,
                  itemBuilder: (c, i) {
                    return InkWell(
                      onTap: () {
                        cont.habitTxtCnt.text = littleCont.seqitems[i]['habit'];

                        Get.to(() => Progression(
                              item: littleCont.seqitems[i],
                            ));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Text(littleCont.seqitems[i]['habit']),
                      ),
                    );
                  });
            },
          )),
    );
  }
}

Object habitGateWithGroup(BuildContext conte, bool isAdd, String id) {
  final cont = Get.find<SequenceCont>();

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
                Navigator.of(conte).pop();
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true, // Set this to true
                backgroundColor: Colors.black.withOpacity(.8),
                body: Center(
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(
                          top: 100, bottom: 100, right: 50, left: 50),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const SizedBox(height: 20),
                          TextField(
                            controller: cont.habitTxtCnt,
                            maxLines:
                                null, // Set maxLines to null for multiline support
                            decoration: const InputDecoration(
                              hintText: 'new habit',
                              border: InputBorder.none,
                            ),
                          ),
                          const Divider(),
                          TextField(
                            controller: cont.importancy,
                            maxLines:
                                null, // Set maxLines to null for multiline support
                            decoration: const InputDecoration(
                              hintText: 'importancy',
                              border: InputBorder.none,
                            ),
                          ),
                          const Divider(),
                          TextField(
                            controller: cont.seqnumber,
                            maxLines:
                                null, // Set maxLines to null for multiline support
                            decoration: const InputDecoration(
                              hintText: 'sequence number',
                              border: InputBorder.none,
                            ),
                          ),
                          const Divider(),
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Checkbox(
                                    onChanged: (v) {
                                      setstate(() {
                                        {
                                          cont.isMoveable = !cont.isMoveable;
                                        }
                                      });
                                    },
                                    value: cont.isMoveable,
                                  ),
                                  const Text('Is Moveable?')
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: InkWell(
                              onTap: () {
                                isAdd
                                    ? cont.insertSequenceItem()
                                    : cont.updateSequenceItem(id);
                                Navigator.of(conte).pop();
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                padding: const EdgeInsets.all(10),
                                child: const Center(
                                  child: Text(
                                    'save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Object addHabit(BuildContext conte, bool isAdd, String id) {
  final cont = Get.find<SequenceCont>();
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
                Navigator.of(conte).pop();
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true, // Set this to true
                backgroundColor: Colors.black.withOpacity(.8),
                body: Center(
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(
                          top: 100, bottom: 100, right: 50, left: 50),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const SizedBox(height: 20),
                          TextField(
                            controller: cont.habitTxtCnt,
                            maxLines:
                                null, // Set maxLines to null for multiline support
                            decoration: const InputDecoration(
                              hintText: 'new habit',
                              border: InputBorder.none,
                            ),
                          ),
                          const Divider(),
                          const TextField(
                            maxLines:
                                null, // Set maxLines to null for multiline support
                            decoration: InputDecoration(
                              hintText: 'importancy',
                              border: InputBorder.none,
                            ),
                          ),
                          const Divider(),
                          const TextField(
                            maxLines:
                                null, // Set maxLines to null for multiline support
                            decoration: InputDecoration(
                              hintText: 'sequence number',
                              border: InputBorder.none,
                            ),
                          ),
                          const Divider(),
                          DropdownButton<String>(
                              value: cont.chosenGroupId,
                              items: [
                                for (int i = 0; i < cont.groupList.length; i++)
                                  DropdownMenuItem(
                                    value: cont.groupList[i]['id'],
                                    child: Text(cont.groupList[i]['name']),
                                  ),
                              ],
                              onChanged: (value) {
                                setstate(() {
                                  cont.chosenGroupId = value!;
                                });
                              }),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: InkWell(
                              onTap: () {
                                isAdd
                                    ? cont.insertSequenceItem()
                                    : cont.updateSequenceItem(id);
                                Navigator.of(conte).pop();
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                padding: const EdgeInsets.all(10),
                                child: const Center(
                                  child: Text(
                                    'save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
