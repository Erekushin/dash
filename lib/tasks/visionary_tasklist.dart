import 'package:erek_dash/tasks/task_cont.dart';
import 'package:erek_dash/tasks/thetask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';

import 'dart:io';

class BoxList extends StatefulWidget {
  const BoxList({super.key});

  @override
  State<BoxList> createState() => _BoxListState();
}

class _BoxListState extends State<BoxList> {
  final cont = Get.find<TaskCont>();
  File? _image;

  Future<void> pickImagefromGallery() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        title: const Text('My Boxes'),
        actions: [
          IconButton(
              onPressed: () {
              
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GetX<TaskCont>(builder: (littleCont) {
          return ListView.builder(
              itemCount: littleCont.boxList.length,
              shrinkWrap: true,
              itemBuilder: (c, i) {
                var item = littleCont.boxList[i];
                var name = item['boxname'];
                return InkWell(
                  onTap: () {
                    Get.to(() => TheTask(
                          item: item,
                        ));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: Colors.black, width: 3)),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                image: item['imgPath'] == '' || item['imgPath'] == null
                                    ? const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/imagedefault.png'),
                                        fit: BoxFit.cover)
                                    : DecorationImage(
                                        image: NetworkImage(item['imgPath']),
                                        fit: BoxFit.cover),
                                color: Colors.grey,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            item['task'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(item['description']),
                          Container()
                        ],
                      )),
                );
              });
        }),
      ),
    );
  }
}
