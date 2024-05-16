import 'package:erek_dash/globals.dart';
import 'package:erek_dash/value/cash_gate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'value_cont.dart';

class ValueHistory extends StatefulWidget {
  const ValueHistory({super.key});

  @override
  State<ValueHistory> createState() => _ValueHistoryState();
}

class _ValueHistoryState extends State<ValueHistory> {
  final cont = Get.find<ValueCont>();

  @override
  void initState() {
    cont.readValueList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        title: const Text('Value History💸'),
      ),
      body: GetX<ValueCont>(builder: (littleCont) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: littleCont.valueHistory.length,
            itemBuilder: (c, i) {
              var item = littleCont.valueHistory[i];
              return InkWell(
                onTap: () {
                  cont.setValues(item);
                  cashGate(context, true, item);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 20, right: 5),
                  alignment: Alignment.centerLeft,
                  width: 300,
                  decoration: BoxDecoration(
                      color: item['active']
                          ? Colors.green
                          : const Color.fromARGB(255, 202, 29, 17),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Row(children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item['active']
                              ? Colors.greenAccent
                              : Colors.redAccent),
                      child: Icon(
                        item['active']
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_outlined,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '${item['value']}₮',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Text(
                        item['created_time'].toString() == ""
                            ? ""
                            : item['created_time'].toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ]),
                  Text( item['description'], style: const TextStyle(color: Colors.white),)
                  ],),
                ),
              );
            });
      }),
    );
  }
}
