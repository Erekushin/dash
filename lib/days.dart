import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'dayreview.dart';
import 'helpers/time.dart';
import 'widgets/buttons.dart';
import 'widgets/snacks.dart';

class Days extends StatelessWidget {
  Days({super.key});

  TimeHelper timeHelper = TimeHelper();
  TextEditingController headdate = TextEditingController();
  RxList tendays = [].obs;
  List<String> getDatesBetween(String startDateStr) {
    final DateFormat format = DateFormat("yyyy-MM-dd");

    DateTime startDate = format.parse(startDateStr);

    List<String> dateList = [];

    for (int i = 0; i < 10; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      dateList.add(format.format(currentDate));
    }
    getActiveDays(dateList);

    return dateList;
  }

  Future getActiveDays(List days) async {
    String query = '''
    SELECT created_time FROM notes WHERE created_time IN (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
     UNION
    SELECT day_date FROM habits_journal WHERE day_date IN (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
     UNION
    SELECT finished_time FROM tasks WHERE finished_time IN (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) AND done_it = 1
    UNION
    SELECT created_time FROM productivityduration WHERE created_time IN (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  ''';
    try {
      // final db = await Erekdatabase.database;

      // tendays.value = await db.rawQuery(
      //   query,
      //   [...days, ...days, ...days, ...days],
      // );
    } catch (e) {
      Snacks.errorSnack(e);

      print('start--- $e   ---end');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.mainColor,
        appBar: AppBar(
          title: const Text('My History'),
        ),
        body: Stack(
          children: [
            Obx(() => ListView.builder(
                itemCount: tendays.length,
                itemBuilder: (c, i) {
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => DayReview(
                                theday: tendays[i]['created_time'],
                              ));
                        },
                        child: Text(
                          tendays[i]['created_time'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30),
                        ),
                      ));
                })),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 100,
                        child: InkWell(
                          onTap: () async {
                            String incomingValue =
                                await timeHelper.selectDate(context);
                            if (incomingValue.isNotEmpty) {
                              headdate.text = incomingValue;
                            }
                          },
                          child: TextField(
                            controller: headdate,
                            decoration:
                                const InputDecoration(hintText: 'head date'),
                            enabled: false,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const Text('to ten days'),
                      standartBtn('refresh', () {
                        if (headdate.text.isNotEmpty) {
                          getDatesBetween(headdate.text);
                        }
                      })
                    ]),
              ),
            )
          ],
        ));
  }
}
