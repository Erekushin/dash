import 'package:erek_dash/dayproductivity/productivity_cont.dart';
import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductivityList extends StatefulWidget {
  const ProductivityList({super.key});

  @override
  State<ProductivityList> createState() => _ProductivityListState();
}

class _ProductivityListState extends State<ProductivityList> {
  final cont = Get.find<ProductivityCont>();
  bool editvisible = false;
  int chosenId = 0;
  @override
  void initState() {
    cont.getAllDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        title: const Text('Productivity List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: GetX<ProductivityCont>(builder: (littleCont) {
                return ListView.builder(
                    itemCount: littleCont.allProductivity.length,
                    shrinkWrap: true,
                    itemBuilder: (c, i) {
                      var item = littleCont.allProductivity[i];
                      List innerItems = item['items'];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            littleCont.expandedbool[i] =
                                !littleCont.expandedbool[i];
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: child,
                              );
                            },
                            child: littleCont.expandedbool[i]
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item['created_time'] ?? '',
                                      ),
                                      Text(innerItems.length.toString())
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Text(
                                        item['created_time'] ?? '',
                                      ),
                                      const SizedBox(height: 20),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: innerItems.length,
                                          itemBuilder: (c, index) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  littleCont.expandedbool[i] =
                                                      !littleCont
                                                          .expandedbool[i];
                                                });
                                              },
                                              onLongPress: () {
                                                chosenId =
                                                    innerItems[index]['id'];
                                                cont.editTxt.text =
                                                    innerItems[index]['note'];
                                                setState(() {
                                                  editvisible = true;
                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.all(5),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: const BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${index + 1}. ",
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(
                                                        width: 300,
                                                        child: Text(
                                                          innerItems[index]
                                                                  ['note'] ??
                                                              'empty',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    });
              }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                  visible: editvisible,
                  child: Container(
                    margin:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Colors.black)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 250,
                            child: TextField(
                              controller: cont.editTxt,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              cont.updateProductivity(chosenId);
                              setState(() {
                                editvisible = false;
                              });
                            },
                            child: const Icon(
                              Icons.update,
                              color: Colors.blueAccent,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              cont.deleteProductivity(chosenId);
                              setState(() {
                                editvisible = false;
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 30,
                            ),
                          )
                        ]),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
