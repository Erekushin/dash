import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'habit_cont.dart';
import '../globals.dart';
import 'habit_progress.dart';

class Habits extends StatefulWidget {
  const Habits({super.key});

  @override
  State<Habits> createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  final cont = Get.find<HabitCont>();

  @override
  void initState() {
    cont.getAllHabits();
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
          child: GetX<HabitCont>(
            builder: (littleCont) {
              return ListView.builder(
                  itemCount: littleCont.habitList.length,
                  itemBuilder: (c, i) {
                    return InkWell(
                      onTap: () {
                        cont.habitTxtCnt.text =
                            littleCont.habitList[i]['habit'];
                        Get.to(() => HabitProgress(
                              item: littleCont.habitList[i],
                              id: littleCont.entryNames[i],
                            ));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Text(littleCont.habitList[i]['habit']),
                      ),
                    );
                  });
            },
          )),
    );
  }
}

Object habitGateWithGroup(BuildContext conte, bool isAdd, String id) {
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
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: InkWell(
                              onTap: () {
                                isAdd
                                    ? cont.insertHabit()
                                    : cont.updateHabit(id);
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
                                    value: cont.groupEntries[i],
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
                                    ? cont.insertHabit()
                                    : cont.updateHabit(id);
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
