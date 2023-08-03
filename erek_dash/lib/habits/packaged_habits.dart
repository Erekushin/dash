import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configuration/conf_cont.dart';
import 'habit_cont.dart';
import '../globals.dart';
import '../helpers/time.dart';
import '../widgets/widget_tools.dart';

class PackagedHabits extends StatefulWidget {
  const PackagedHabits({super.key});

  @override
  State<PackagedHabits> createState() => _PackagedHabitsState();
}

class _PackagedHabitsState extends State<PackagedHabits> {
  final cont = Get.find<HabitCont>();
  final confCont = Get.find<ConfigurationCont>();
  TimeHelper timeHelper = TimeHelper();
  @override
  void initState() {
    cont.packageHabits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: GetX<HabitCont>(
            builder: (littleCont) {
              return ListView.builder(
                  itemCount: littleCont.packagedList.length,
                  itemBuilder: (c, i) {
                    return littleCont.packagedList[i].isDone
                        ? InkWell(
                            onTap: () {
                              habitGate(context, littleCont.packagedList[i]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.black, width: 3),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.all(10),
                              child: Text(littleCont
                                  .packagedList[i].actualData['habit']),
                            ))
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                border:
                                    Border.all(color: Colors.green, width: 3),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          );
                  });
            },
          )),
    );
  }

  Object habitGate(BuildContext conte, CurrentHabit item) {
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
                  if (cont.stardedtimeofHabit.text.isNotEmpty &&
                      cont.finfishedtimeofHabit.text.isNotEmpty &&
                      cont.successPointofHabit.text.isNotEmpty) {
                    cont.insertTaskProgress(
                        item.actualData,
                        cont.stardedtimeofHabit.text,
                        cont.finfishedtimeofHabit.text,
                        cont.successPointofHabit.text);
                  }
                  Navigator.of(context).pop();
                },
                child: Scaffold(
                  resizeToAvoidBottomInset: true, // Set this to true
                  backgroundColor: Colors.black.withOpacity(.8),
                  body: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          margin: const EdgeInsets.only(
                              left: 40, right: 40, top: 5, bottom: 5),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              taskProperty(
                                  'starting time',
                                  TextField(
                                    enabled: false,
                                    textAlign: TextAlign.center,
                                    controller: cont.stardedtimeofHabit,
                                  ), () async {
                                cont.stardedtimeofHabit.text =
                                    await timeHelper.selectTime(context);
                              }),
                              taskProperty(
                                  'finished time',
                                  TextField(
                                    textAlign: TextAlign.center,
                                    enabled: false,
                                    controller: cont.finfishedtimeofHabit,
                                  ), () async {
                                cont.finfishedtimeofHabit.text =
                                    await timeHelper.selectTime(context);
                              }),
                              taskProperty(
                                  'success point',
                                  TextField(
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    controller: cont.successPointofHabit,
                                  ),
                                  () {})
                            ],
                          ),
                        ),
                      ],
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
}
