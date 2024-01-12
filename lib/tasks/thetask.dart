import 'package:erek_dash/tasks/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart' as treeview;
import 'package:get/get.dart';
import '../tasks/task_cont.dart';
import '../tasks/task_gate.dart';

// ignore: must_be_immutable
class TheTask extends StatefulWidget {
  TheTask({super.key, required this.item});
  // ignore: prefer_typing_uninitialized_variables
  var item;
  @override
  State<TheTask> createState() => _TheTaskState();
}

class _TheTaskState extends State<TheTask> {
  final taskCont = Get.find<TaskCont>();
  late treeview.TreeViewController _treeViewController;
  @override
  void initState() {
    _treeViewController = treeview.TreeViewController(
      children: taskCont.treeTasks,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item['task']),
        actions: [
          IconButton(
              onPressed: () {
                taskCont.deleteTask(widget.item['id'], widget.item['imgPath']);
              },
              icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () {
                int a = 4;
                print('dfd');
                taskCont.setValues(widget.item);
                taskCont.isActive = !taskCont.isActive;
                print(taskCont.isActive);
                taskCont.updateTask(widget.item['id'], widget.item['imgPath']);
              },
              icon: Icon(
                Icons.assignment_turned_in_outlined,
                color: widget.item['active'] ? Colors.greenAccent : Colors.grey,
              )),
          IconButton(
              onPressed: () {
                taskCont.setValues(widget.item);
                Get.to(() => Task(
                      item: widget.item,
                      id: widget.item['id'],
                      selectedLabelid: widget.item['boxId'] ?? 0,
                      selectedLabelname: widget.item['boxname'] ?? '',
                    ));
              },
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              image:
                  widget.item['imgPath'] == '' || widget.item['imgPath'] == null
                      ? const DecorationImage(
                          image: AssetImage('assets/images/imagedefault.png'),
                          fit: BoxFit.cover)
                      : DecorationImage(
                          image: NetworkImage(widget.item['imgPath']),
                          fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.item['task'],
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(widget.item['description']),
          Padding(
              padding: const EdgeInsets.all(10),
              child: treeview.TreeView(
                shrinkWrap: true,
                controller: _treeViewController,
                nodeBuilder: (c, node) {
                  return InkWell(
                    onTap: () {
                      taskCont.setValues(node.data);
                      Get.to(() => Task(
                            item: node.data,
                            id: node.data['id'],
                            selectedLabelid: node.data['boxId'] ?? 0,
                            selectedLabelname: node.data['boxname'] ?? '',
                          ));
                    },
                    onLongPress: () {
                      taskCont.setsubValues(node.data);
                      Get.to(() => TaskGate(
                            item: node.data,
                            incomingIsMoving: false,
                          ));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Row(children: [
                        Text(node.label),
                        const Spacer(),
                        Text(node.data['step'].toString())
                      ]),
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }
}
