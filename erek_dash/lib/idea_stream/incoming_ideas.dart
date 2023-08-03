import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'idea_stream_cont.dart';
import 'info_edit.dart';

class IncomingIdeas extends StatefulWidget {
  const IncomingIdeas({super.key});

  @override
  State<IncomingIdeas> createState() => _IncomingIdeasState();
}

class _IncomingIdeasState extends State<IncomingIdeas> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20),
        child: GetX<IdeaStreamCont>(builder: (littleCont) {
          return MasonryGridView.count(
            itemCount: littleCont.ideaList.length,
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  littleCont.ideaEditorCont.text =
                      littleCont.ideaList[index]['incoming_idea'];
                  littleCont.firstValue =
                      littleCont.ideaList[index]['incoming_idea'];
                  Get.to(() => InfoEdit(id: littleCont.ideaList[index]['id']));
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Text(
                    littleCont.ideaList[index]['incoming_idea'],
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            },
          );
        }));
  }
}
