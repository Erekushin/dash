import 'dart:typed_data';

import 'package:erek_dash/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/snacks.dart';

class BoxCont extends GetxController {
  String path = '';

  RxList boxList = [].obs;
  List entryNames = [];
  Future allBoxes() async {
    try {
      DatabaseEvent a =
          await StaticHelpers.databaseReference.child(path).once();
      if (a.snapshot.exists) {
        Map<dynamic, dynamic> data = a.snapshot.value as Map<dynamic, dynamic>;
        boxList.value = data.values.toList();

        entryNames = data.keys.toList();
      } else {
        boxList.clear();
        entryNames.clear();
      }
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  Map<String, dynamic> boxValues(String imgPath) {
    Map<String, dynamic> data = <String, dynamic>{};
    data['boxname'] = boxNameTxt.text;
    data['created_time'] = GlobalValues.nowStrShort;
    data['updated_time'] = GlobalValues.nowStr;
    data['discription'] = discripctionTxt.text;
    data['picture'] = imgPath;
    return data;
  }

  TextEditingController boxNameTxt = TextEditingController();
  TextEditingController discripctionTxt = TextEditingController();
  String imgPath = '';
  insertBox() async {
    try {
      String productId = StaticHelpers.id;
      if (boxImg.isNotEmpty) {
        imgPath = await uplodImage(productId, boxNameTxt.text);
      }
      if (boxNameTxt.text.isNotEmpty) {
        StaticHelpers.databaseReference
            .child('$path/$productId')
            .set(boxValues(imgPath))
            .whenComplete(() {
          allBoxes();
          boxNameTxt.clear();
          discripctionTxt.clear();
          imgPath = '';
        });
      }
    } catch (e) {
      Snacks.errorSnack(e);
      print(e.toString());
    }
  }

  updateBox(int id) async {
    try {
      StaticHelpers.databaseReference
          .child('$path/$id')
          .set(boxValues(imgPath))
          .whenComplete(() {
        allBoxes();
        boxNameTxt.clear();
        discripctionTxt.clear();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  deleteBox(
    String id,
  ) async {
    try {
      StaticHelpers.databaseReference.child('$path/$id').remove().then((_) {
        allBoxes();
        Get.back();
      });
    } catch (e) {
      Snacks.errorSnack(e);
    }
  }

  RxList<Uint8List> boxImg = <Uint8List>[].obs;
  Future uplodImage(String productId, String imgName) async {
    final storage = FirebaseStorage.instance;
    final metaData = SettableMetadata(contentType: 'image/png');

    final reference = storage
        .ref()
        .child('${StaticHelpers.userInfo!.uid}/box_pics/$productId')
        .child(imgName);
    UploadTask uploadTask = reference.putData(boxImg[0], metaData);
    TaskSnapshot snapShot = await uploadTask.whenComplete(() {
      boxImg.clear();
      print('proccess complited');
    });
    final imageUrl = await snapShot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> deleteImageFromStorage(String imgUrl) async {
    try {
      // Create a reference to the Firebase Storage file using the image URL
      Reference storageReference = FirebaseStorage.instance.refFromURL(imgUrl);

      // Delete the file
      await storageReference.delete();

      // Image deleted successfully
      print('Image deleted successfully');
    } catch (error) {
      // Handle any errors that occur during the deletion process
      print('Error deleting image: $error');
    }
  }
}
