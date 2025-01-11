import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart';
import 'boxcont.dart';

import 'thebox.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BoxList extends StatefulWidget {
  const BoxList({super.key});

  @override
  State<BoxList> createState() => _BoxListState();
}

class _BoxListState extends State<BoxList> {
  final cont = Get.find<BoxCont>();
  File? _image;

  Future<void> pickImagefromGallery() async {}

  @override
  void initState() {
    cont.allBoxes();
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
                boxGate(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GetX<BoxCont>(builder: (littleCont) {
          return ListView.builder(
              itemCount: littleCont.boxList.length,
              shrinkWrap: true,
              itemBuilder: (c, i) {
                var item = littleCont.boxList[i];
                var name = item['boxname'];
                return InkWell(
                  onTap: () {
                    Get.to(() => TheBox(
                          item: item,
                          id: littleCont.entryNames[i],
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
                                image: item['picture'] == ''
                                    ? const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/imagedefault.png'),
                                        fit: BoxFit.cover)
                                    : DecorationImage(
                                        image: NetworkImage(item['picture']),
                                        fit: BoxFit.cover),
                                color: Colors.grey,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            item['boxname'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(item['discription']),
                          Container()
                        ],
                      )),
                );
              });
        }),
      ),
    );
  }

  Object boxGate(BuildContext conte) {
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
                  Get.back();
                  cont.insertBox();
                  _image = null;
                },
                child: Scaffold(
                  resizeToAvoidBottomInset: true, // Set this to true
                  backgroundColor: Colors.black.withOpacity(.8),
                  body: Center(
                    child: SizedBox(
                      width: 250,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            height: 80,
                            child: Card(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              shadowColor: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: cont.boxNameTxt,
                                  maxLines:
                                      null, // Set maxLines to null for multiline support
                                  decoration: const InputDecoration(
                                      hintText: 'Box Name',
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 150,
                            child: Card(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              shadowColor: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: cont.discripctionTxt,
                                  maxLines:
                                      null, // Set maxLines to null for multiline support
                                  decoration: const InputDecoration(
                                      hintText: 'Discription',
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 150,
                            child: InkWell(
                              onTap: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery);

                                if (pickedFile != null) {
                                  _image = File(pickedFile.path);
                                  final imageBytes =
                                      await pickedFile.readAsBytes();
                                  cont.boxImg.insert(0, imageBytes);
                                }
                                setstate(() {});
                              },
                              child: Card(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shadowColor: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: _image != null
                                        ? Image.file(
                                            _image!,
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          )
                                        : Stack(children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/imagedefault.png'))),
                                            ),
                                            const Center(
                                              child: Icon(
                                                Icons.add,
                                                size: 60,
                                                color: Colors.grey,
                                              ),
                                            )
                                          ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: Card(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              shadowColor: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 120,
                                      margin: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          color: Colors.redAccent),
                                    ),
                                    //ongo songodog yum tavih
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
