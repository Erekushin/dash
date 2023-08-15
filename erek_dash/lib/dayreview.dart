import 'package:erek_dash/dayproductivity/productivity_cont.dart';
import 'package:erek_dash/globals.dart';
import 'package:erek_dash/habits/habit_cont.dart';
import 'package:erek_dash/tasks/task_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notes/note_cont.dart';

class DayReview extends StatefulWidget {
  const DayReview({super.key});

  @override
  State<DayReview> createState() => _DayReviewState();
}

class _DayReviewState extends State<DayReview> {
  final noteCont = Get.find<NoteCont>();
  final habitCont = Get.find<HabitCont>();
  final taskCont = Get.find<TaskCont>();
  final productivityCont = Get.find<ProductivityCont>();
  @override
  void initState() {
    noteCont.getToday();
    habitCont.dayHabitProgress();
    taskCont.getDayComplitedTasks();
    productivityCont.getCurrentDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GlobalValues.nowStrShort),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GetX<ProductivityCont>(builder: (productivityContlittle) {
              return eachContainer(
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                          children: [
                        const TextSpan(text: 'success of '),
                        TextSpan(
                          text: productivityContlittle.dayProductivity.length
                              .toString(),
                        ),
                        const TextSpan(text: ' hours')
                      ])),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: productivityContlittle.dayProductivity.length,
                      itemBuilder: (c, i) {
                        var item = productivityContlittle.dayProductivity[i];
                        return Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 5, top: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            children: [
                              Text('${i + 1}. '),
                              Expanded(flex: 3, child: Text(item['note'])),
                            ],
                          ),
                        );
                      }),
                  'What I have done');
            }),
            GetX<TaskCont>(builder: (taskContlittle) {
              return eachContainer(
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                          children: [
                        const TextSpan(text: 'success of '),
                        TextSpan(
                          text: taskContlittle.dayComplitedTasks.length
                              .toString(),
                        ),
                        const TextSpan(text: ' compited tasks')
                      ])),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: taskContlittle.dayComplitedTasks.length,
                      itemBuilder: (c, i) {
                        var item = taskContlittle.dayComplitedTasks[i];
                        return Row(
                          children: [
                            Expanded(flex: 3, child: Text(item['task'])),
                            Expanded(
                                flex: 2,
                                child: Text(item['labelname'].toString())),
                            Expanded(
                                flex: 1,
                                child: Text(item['importancy'].toString())),
                          ],
                        );
                      }),
                  'What I completed');
            }),
            GetX<HabitCont>(builder: (habitContlittle) {
              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 8,
                          color: Colors.grey.shade400,
                          offset: const Offset(0, 5))
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Column(children: [
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: habitContlittle.dayProgress.length,
                      itemBuilder: (c, i) {
                        var item = habitContlittle.dayProgress[i];
                        return Row(
                          children: [
                            Expanded(flex: 3, child: Text(item['habit'])),
                            Expanded(
                                flex: 1, child: Text(item['starting_time'])),
                            Expanded(
                                flex: 1, child: Text(item['finished_time'])),
                            Text(item['success_count'].toString()),
                          ],
                        );
                      }),
                  const Divider(),
                  const Text('progress of the day'),
                ]),
              );
            }),
            GetX<NoteCont>(builder: (noteContlittle) {
              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 8,
                          color: Colors.grey.shade400,
                          offset: const Offset(0, 5))
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Column(children: [
                  Text(noteContlittle.today.isNotEmpty
                      ? noteContlittle.today.first['title']
                      : ''),
                  const Divider(),
                  Text(noteContlittle.today.isNotEmpty
                      ? noteContlittle.today.first['note']
                      : 'here is no note yet'),
                  const Divider(),
                  const Text('Note for the day'),
                ]),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget eachContainer(Widget child1, Widget child2, String title) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                spreadRadius: 2,
                blurRadius: 8,
                color: Colors.grey.shade400,
                offset: const Offset(0, 5))
          ],
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Column(children: [
        child1,
        const Divider(),
        child2,
        const Divider(),
        Text(title),
      ]),
    );
  }
}
