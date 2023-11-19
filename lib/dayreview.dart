import 'package:erek_dash/dayproductivity/productivity_cont.dart';
import 'package:erek_dash/sequences/sequence_cont.dart';
import 'package:erek_dash/tasks/task_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'knowledge/note_cont.dart';

class DayReview extends StatefulWidget {
  DayReview({super.key, required this.theday});
  String theday;
  @override
  State<DayReview> createState() => _DayReviewState();
}

class _DayReviewState extends State<DayReview> {
  final noteCont = Get.find<NoteCont>();
  final habitCont = Get.find<SequenceCont>();
  final taskCont = Get.find<TaskCont>();
  final productivityCont = Get.find<ProductivityCont>();

  @override
  void initState() {
    // habitCont.dayHabitProgress(widget.theday);
    noteCont.getToday(widget.theday);

    taskCont.getDayComplitedTasks(widget.theday);
    productivityCont.getCurrentDay(widget.theday);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.theday),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GetX<ProductivityCont>(builder: (productivityContlittle) {
              return productivityContlittle.dayProductivity.isEmpty
                  ? const SizedBox()
                  : eachContainer(
                      Text(
                        'success of ${productivityContlittle.dayProductivity.length} hours',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              productivityContlittle.dayProductivity.length,
                          itemBuilder: (c, i) {
                            var item =
                                productivityContlittle.dayProductivity[i];
                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5, top: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Row(
                                children: [
                                  Text(
                                    '${i + 1}. ',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        item['note'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )),
                                ],
                              ),
                            );
                          }),
                    );
            }),
            GetX<TaskCont>(builder: (taskContlittle) {
              return taskContlittle.dayComplitedTasks.isEmpty
                  ? const SizedBox()
                  : eachContainer(
                      Text(
                          '${taskContlittle.dayComplitedTasks.length} success is completed',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          )),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: taskContlittle.dayComplitedTasks.length,
                          itemBuilder: (c, i) {
                            var item = taskContlittle.dayComplitedTasks[i];
                            return Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black, width: 0.4))),
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['task'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'importancy : ${item['importancy'].toString()}',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Text(item['labelname'].toString()),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                    );
            }),
            GetX<SequenceCont>(builder: (habitContlittle) {
              return habitContlittle.dayProgress.isEmpty
                  ? const SizedBox()
                  : eachContainer(
                      Text(
                          '${habitContlittle.dayProgress.length} habit is completed',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          )),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: habitContlittle.dayProgress.length,
                              itemBuilder: (c, i) {
                                var item = habitContlittle.dayProgress[i];
                                return Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          item['habit'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Text(item['starting_time'])),
                                    Expanded(
                                        flex: 1,
                                        child: Text(item['finished_time'])),
                                    Text(item['success_count'].toString()),
                                  ],
                                );
                              }),
                        ]),
                      ));
            }),
            GetX<NoteCont>(builder: (noteCont) {
              return noteCont.noteoftheday.isEmpty
                  ? const SizedBox()
                  : Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              noteCont.noteoftheday.first['title'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic),
                            ),
                            const Divider(),
                            Text(
                              noteCont.noteoftheday.first['note'],
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ]),
                    );
            })
          ],
        ),
      ),
    );
  }

  Widget eachContainer(Widget child1, Widget child2) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        child1,
        const Divider(
          thickness: 1,
          color: Colors.black,
        ),
        child2,
      ]),
    );
  }
}
