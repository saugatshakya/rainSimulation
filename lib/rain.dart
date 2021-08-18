import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rain/raindrop.dart';

class Rain extends StatefulWidget {
  const Rain({Key? key}) : super(key: key);

  @override
  _RainState createState() => _RainState();
}

class _RainState extends State<Rain> {
  late Timer timer;
  late List raindrops;
  late List dropheight;
  late List<double> dropXlocations;
  late List<double> dropYlocations;
  Color color = Colors.white;
  bool thunder = false;
  bool willthunder = false;
  List<Color> colorList = [
    Color(0xffd0605e),
    Color(0xff7b95b6),
    Color(0xffc5aca7),
    Color(0xfffab395),
    Color(0xfffcf7c7),
    Color(0xff8f3d4b),
    Color(0xff743d73),
    Color(0xff4a2f48),
    Color(0xff392033),
    Color(0xff2b1d42),
    Color(0xff20115b),
    Color(0xff311518),
    Color(0xff140e36),
    Color(0xff010108),
    Colors.black,
    Color(0xff424753),
    Color(0xff745669),
    Color(0xff8d4c17),
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = Color(0xff20115b);
  Color topColor = Color(0xff140e36);
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;
  int speed = 10;
  int dense = 400;
  bool playing = false;
  double gravity = 9.8;
  double wind = 0;
  play() {
    timer = Timer.periodic(Duration(milliseconds: speed), (timer) {
      for (int i = 0; i < dense; i++) {
        dropXlocations[i] =
            (dropXlocations[i] + gravity * 5 * (dropheight[i] / 40));
        dropYlocations[i] =
            (dropYlocations[i] + wind * 5 * (dropheight[i] / 40));
        if (dropXlocations[i] >= 800) {
          dropXlocations[i] = Random().nextInt(100) * -1;
        }
        if (dropYlocations[i] >= 1600) {
          dropYlocations[i] = Random().nextInt(10) * -1;
        }
      }
      Random().nextInt(100) == 1 ? thunder = true : thunder = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    dropheight = [
      for (int i = 0; i < dense; i++) Random().nextInt(40 - 10) + 10
    ];
    dropXlocations = [
      for (int i = 0; i < dense; i++) (Random().nextInt(600 - 100) + 100) * -1
    ];
    dropYlocations = [
      for (int i = 0; i < dense; i++) Random().nextInt(1600 - 10) + 10
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        bottomColor = Colors.blue;
      });
    });
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          Center(
            child: AnimatedContainer(
              duration: Duration(seconds: 30),
              curve: Curves.linear,
              onEnd: () {
                setState(() {
                  index = index + 1;
                  // animate the color
                  bottomColor = colorList[index % colorList.length];
                  topColor = colorList[(index + 1) % colorList.length];

                  //// animate the alignment
                  begin = alignmentList[index % alignmentList.length];
                  end = alignmentList[(index + 2) % alignmentList.length];
                });
              },
              height: 800,
              width: 1600,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: begin, end: end, colors: [bottomColor, topColor])),
              child: Stack(
                children: [
                  for (int i = 0; i < dense; i++)
                    Positioned(
                        top: dropXlocations[i],
                        left: dropYlocations[i],
                        child: Transform.rotate(
                          angle: wind == 0
                              ? 0
                              : wind <= 2
                                  ? (-5 * pi / 180)
                                  : wind <= 5
                                      ? (-10 * pi / 180)
                                      : wind <= 7
                                          ? (-15 * pi / 180)
                                          : wind <= 9
                                              ? (-20 * pi / 180)
                                              : (-25 * pi / 180),
                          child: RainDrop(
                            color: color,
                            height: dropheight[i],
                          ),
                        )),
                  thunder && willthunder
                      ? Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        )
                      : Container()
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        playing = !playing;
                        playing ? play() : timer.cancel();
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      width: 100,
                      height: 40,
                      child: Center(
                        child: Text(
                          "Play",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Column(children: [
                    Container(
                      height: 40,
                      child: Slider(
                          value: dense * 1,
                          max: 400,
                          min: 10,
                          onChanged: (val) {
                            setState(() {
                              dense = val.truncate();
                            });
                          }),
                    ),
                    Text(
                      "Rain Intensity",
                      style: TextStyle(color: Colors.white),
                    )
                  ]),
                  Column(children: [
                    Container(
                      height: 40,
                      child: Slider(
                          value: wind * 1,
                          max: 10,
                          min: 0,
                          onChanged: (val) {
                            setState(() {
                              wind = val;
                            });
                          }),
                    ),
                    Text(
                      "Wind Intensity",
                      style: TextStyle(color: Colors.white),
                    )
                  ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              willthunder = !willthunder;
                            });
                          },
                          child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white)),
                              child: Center(
                                child: willthunder
                                    ? Container(
                                        width: 20,
                                        height: 20,
                                        color: Colors.white)
                                    : Container(),
                              )),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Thunder",
                          style: TextStyle(color: Colors.white),
                        )
                      ])
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
