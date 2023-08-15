import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';
import 'boxcont.dart';

// ignore: must_be_immutable
class TheBox extends StatefulWidget {
  TheBox({super.key, required this.item});
  // ignore: prefer_typing_uninitialized_variables
  var item;
  @override
  State<TheBox> createState() => _TheBoxState();
}

class _TheBoxState extends State<TheBox> {
  final cont = Get.find<BoxCont>();

  void deleteFile(String filePath) async {
    try {
      File file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        print('File deleted successfully');
        cont.deleteBox(widget.item['id']);
        Get.back();
      } else {
        print('File not found');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item['boxname']),
        actions: [
          IconButton(
              onPressed: () {
                deleteFile(widget.item['picture']);
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
              image: DecorationImage(
                  image: FileImage(
                    File(widget.item['picture']),
                  ),
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
