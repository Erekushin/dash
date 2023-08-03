import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'habit_cont.dart';
import '../globals.dart';
import '../widgets/addhabit.dart';
import 'habit_progress.dart';

class Habits extends StatefulWidget {
  const Habits({super.key});

  @override
  State<Habits> createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  final cont = Get.find<HabitCont>();
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
            addHabit(context, true, 0);
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
                            ));
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
                              littleCont.habitList[i]['habit'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Icon(
                              Icons.arrow_right,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
          )),
    );
  }
}
