import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../habits/habit_cont.dart';
import '../globals.dart';

Object addHabit(BuildContext conte, bool isAdd, int id) {
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
                          DropdownButton<Map<String, dynamic>>(
                              value: cont.selectedValue,
                              items: [
                                for (var item in GlobalStatics.habitType)
                                  DropdownMenuItem(
                                    value: item,
                                    child: Text(item['name']),
                                  ),
                              ],
                              onChanged: (value) {
                                setstate(() {
                                  cont.selectedValue = value!;
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
