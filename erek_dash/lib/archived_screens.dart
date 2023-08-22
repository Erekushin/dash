import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dayproductivity/productivity_list.dart';
import 'days.dart';
import 'notes/notes.dart';
import 'tasks/completed_tasks.dart';

class ArchivedScreens extends StatefulWidget {
  const ArchivedScreens({super.key});

  @override
  State<ArchivedScreens> createState() => _ArchivedScreensState();
}

class _ArchivedScreensState extends State<ArchivedScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              children: [
                menuCard('Notes', 'assets/images/note-taking.png', () {
                  Get.to(() => const Notes());
                }),
                menuCard('Complited tasks', 'assets/images/relief.jpg', () {
                  Get.to(() => const CompletedTasks());
                }),
              ],
            ),
            Row(
              children: [
                menuCard('productivity hours', 'assets/images/productivity.jpg',
                    () {
                  Get.to(() => const ProductivityList());
                }),
                menuCard('days', 'assets/images/days.jpg', () {
                  Get.to(() => Days());
                }),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Widget menuCard(String title, String img, Function func) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: InkWell(
          onTap: () {
            func();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(0, 5),
                      spreadRadius: 4,
                      blurRadius: 10)
                ]),
            child: Column(children: [
              Container(
                width: 120,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                        image: AssetImage(img), fit: BoxFit.cover)),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(title),
              const SizedBox(
                height: 10,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
