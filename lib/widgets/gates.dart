import 'package:flutter/material.dart';

Object productivityGate(BuildContext conte, String hintxt,
    TextEditingController txtCont, Function func) {
  return showGeneralDialog(
    context: conte,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(conte).modalBarrierDismissLabel,
    barrierColor: const Color.fromARGB(133, 0, 0, 0),
    pageBuilder: (conte, anim1, anim2) {
      return SafeArea(
        child: GestureDetector(
          onTap: () {
            func();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true, // Set this to true
            backgroundColor: Colors.black.withOpacity(.8),
            body: Center(
              child: SizedBox(
                width: 300,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Card(
                        color: Colors.white,
                        shadowColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: txtCont,
                            maxLines:
                                null, // Set maxLines to null for multiline support
                            decoration: InputDecoration(
                                hintText: hintxt, border: InputBorder.none),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
