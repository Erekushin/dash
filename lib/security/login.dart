import 'package:erek_dash/globals.dart';
import 'package:erek_dash/security/security_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    var cont = Get.find<SecurityCont>();
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Container(
            alignment: Alignment.center,
            width: 300,
            height: 60,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: TextField(
              obscureText: true,
              onChanged: (e) {
                if (cont.inputtxt.text.length == 4 &&
                    cont.inputtxt.text == "2421") {
                  cont.getUid();
                }
              },
              controller: cont.inputtxt,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'password '),
            ),
          ), 
          Obx(() => Visibility( 
            visible: cont.loadingVis.value,
            child: const CircularProgressIndicator()))
        ]),
      ),
    );
  }
}
