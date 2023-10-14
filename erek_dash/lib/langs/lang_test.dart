import 'dart:ui';
import 'package:erek_dash/globals.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class LangTest extends StatefulWidget {
  LangTest({required this.words});
  List words;
  @override
  _LangTestState createState() => new _LangTestState();
}

class _LangTestState extends State<LangTest> with TickerProviderStateMixin {
  double _page = 10;

  List<AnimationController> animeConts = <AnimationController>[];
  final List<Animation> _animes = <Animation>[];
  final List<AnimationStatus> _statuses = <AnimationStatus>[];
  void initState() {
    super.initState();
    for (int i = 0; i < widget.words.length; i++) {
      _statuses.add(AnimationStatus.dismissed);
      animeConts.add(AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)));
      _animes.add(Tween(end: 1, begin: 0.0).animate(animeConts[i])
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {
          _statuses[i] = status;
        }));
    }
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController;
    pageController = PageController(initialPage: 10);
    pageController.addListener(
      () {
        setState(
          () {
            _page = pageController.page!;
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              height: Sizes.gHeight,
              width: Sizes.gWidth * .95,
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  List<Widget> cards = <Widget>[];

                  for (int i = 0; i < widget.words.length; i++) {
                    double currentPageValue = i - _page;
                    bool pageLocation = currentPageValue > 0;

                    double start = 20 +
                        max(
                            (boxConstraints.maxWidth - Sizes.gWidth * .75) -
                                ((boxConstraints.maxWidth -
                                            Sizes.gWidth * .75) /
                                        2) *
                                    -currentPageValue *
                                    (pageLocation ? 9 : 1),
                            0.0);

                    var customizableCard = Positioned.directional(
                        top: 20 + 30 * max(-currentPageValue, 0.0),
                        bottom: 20 + 30 * max(-currentPageValue, 0.0),
                        start: start,
                        textDirection: TextDirection.ltr,
                        child: Transform(
                          alignment: FractionalOffset.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0015)
                            ..rotateY(pi * _animes[i].value),
                          child: SizedBox(
                            child: _animes[i].value <= 0.5
                                ? Container(
                                    height: Sizes.gWidth,
                                    width: Sizes.gWidth * .67,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: MyColors.mainColor,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.white.withOpacity(.15),
                                              blurRadius: 10)
                                        ]),
                                    child: Text(
                                      widget.words[i]['word'],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 40),
                                    ),
                                  )
                                : Container(
                                    height: Sizes.gWidth,
                                    width: Sizes.gWidth * .67,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(.15),
                                              blurRadius: 10)
                                        ]),
                                    child: Transform.flip(
                                      flipX: true,
                                      child: Text(
                                        widget.words[i]['translation'],
                                        textDirection: TextDirection.ltr,
                                        style: TextStyle(
                                          color: MyColors.mainColor,
                                          fontSize: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ));
                    cards.add(customizableCard);
                  }
                  return Stack(children: cards);
                },
              ),
            ),
            Positioned.fill(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: widget.words.length,
                controller: pageController,
                itemBuilder: (context, index) {
                  return Container(
                    child: InkWell(
                      onDoubleTap: () {
                        if (_statuses[index] == AnimationStatus.dismissed) {
                          animeConts[index].forward();
                        } else {
                          animeConts[index].reverse();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
