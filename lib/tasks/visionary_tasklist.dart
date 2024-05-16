import 'package:erek_dash/tasks/task_cont.dart';
import 'package:erek_dash/tasks/thetask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;

import '../globals.dart';
import 'package:flutter/physics.dart';

class BoxList extends StatefulWidget {
  const BoxList({super.key});

  @override
  State<BoxList> createState() => _BoxListState();
}

class _BoxListState extends State<BoxList> {
  final cont = getx.Get.find<TaskCont>();
  bool gridView = false;
  Future<void> pickImagefromGallery() async {}

  @override
  void initState() {
    super.initState();
    cont.readAllBoxes();
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
                setState(() {
                  gridView = !gridView;
                });
              },
              icon: const Icon(Icons.toggle_on_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: getx.GetX<TaskCont>(builder: (littleCont) {
          return gridView
              ? Stack(
                  children: [
                    for (int i = 0; i < littleCont.allBoxList.length; i++)
                      DraggableCard(
                        isActive:  littleCont.allBoxList[i]['active'],
                        vall: i,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.fastLinearToSlowEaseIn,
                          height: 80,
                          width: 100,
                          decoration: BoxDecoration(
                            color: littleCont.allBoxList[i]['active']
                                ? const Color(0xff8639FB)
                                : const Color.fromARGB(255, 80, 80, 80),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                            boxShadow: [
                              littleCont.allBoxList[i]['active']
                                  ? BoxShadow(
                                      color: const Color(0xff8639FB)
                                          .withOpacity(0.7),
                                      blurRadius: 30,
                                    )
                                  : const BoxShadow(),
                            ],
                          ),
                          child: InkWell(
                            onDoubleTap: () {
                              getx.Get.to(() => TheTask(
                                    item: littleCont.allBoxList[i],
                                  ));
                            },
                            child: Center(
                              child: Text(
                                littleCont.allBoxList[i]['task'],
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                )
              : ListView.builder(
                  itemCount: littleCont.allBoxList.length,
                  shrinkWrap: true,
                  itemBuilder: (c, i) {
                    var item = littleCont.allBoxList[i];
                    return InkWell(
                      onTap: () {
                        getx.Get.to(() => TheTask(
                              item: item,
                            ));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              border:
                                  Border.all(color: Colors.black, width: 3)),
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    image: item['imgPath'] == '' ||
                                            item['imgPath'] == null
                                        ? const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/imagedefault.png'),
                                            fit: BoxFit.cover)
                                        : DecorationImage(
                                            image:
                                                NetworkImage(item['imgPath']),
                                            fit: BoxFit.cover),
                                    color: Colors.grey,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                item['task'],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container()
                            ],
                          )),
                    );
                  });
        }),
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  final Widget child;

  DraggableCard({required this.child, required this.vall, required this.isActive});
  int vall;
  bool isActive;
  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  var _dragAlignment;

  Animation<Alignment>? _animation;

  final _spring = const SpringDescription(
    mass: 10,
    stiffness: 1000,
    damping: 0.9,
  );

  double _normalizeVelocity(Offset velocity, Size size) {
    final normalizedVelocity = Offset(
      velocity.dx / size.width,
      velocity.dy / size.height,
    );
    return -normalizedVelocity.distance;
  }

  void _runAnimation(Offset velocity, Size size) {
    _animation = _controller!.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );

    final simulation =
        SpringSimulation(_spring, 0, 0.0, _normalizeVelocity(velocity, size));

    _controller!.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
      _dragAlignment =
        Alignment((widget.vall * 0.03) - 1, (widget.vall * 0.03) - 1);
    // if(widget.isActive){
    //   _dragAlignment =
    //     Alignment((widget.vall * 0.03) - 1, (widget.vall * 0.03) - 1);
    // }else{
    //     _dragAlignment =
    //     Alignment((widget.vall * 0.03) - 1, -((widget.vall * 0.03) - 1));
    // }
    
    _controller = AnimationController.unbounded(vsync: this)
      ..addListener(() => setState(() => _dragAlignment = _animation!.value));
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanStart: (details) => _controller!.stop(canceled: true),
      onPanUpdate: (details) => setState(
        () => _dragAlignment += Alignment(
          details.delta.dx / (size.width / 2),
          details.delta.dy / (size.height / 2),
        ),
      ),
      onPanEnd: (details) =>
          _runAnimation(details.velocity.pixelsPerSecond, size),
      child: Align(
        alignment: _dragAlignment,
        child: Card(
          child: widget.child,
        ),
      ),
    );
  }
}
