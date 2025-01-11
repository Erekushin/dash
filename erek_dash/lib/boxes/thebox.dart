
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'boxcont.dart';

// ignore: must_be_immutable
class TheBox extends StatefulWidget {
  TheBox({super.key, required this.item, required this.id});
  // ignore: prefer_typing_uninitialized_variables
  var item;
  String id;
  @override
  State<TheBox> createState() => _TheBoxState();
}

class _TheBoxState extends State<TheBox> {
  final cont = Get.find<BoxCont>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item['boxname']),
        actions: [
          IconButton(
              onPressed: () {
                if (widget.item['picture'] != '') {
                  cont.deleteImageFromStorage(widget.item['picture']);
                }

                cont.deleteBox(widget.id);
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              image: widget.item['picture'] == ''
                  ? const DecorationImage(
                      image: AssetImage('assets/images/imagedefault.png'),
                      fit: BoxFit.cover)
                  : DecorationImage(
                      image: NetworkImage(widget.item['picture']),
                      fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.item['boxname'],
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(widget.item['discription']),
        ],
      ),
    );
  }
}
