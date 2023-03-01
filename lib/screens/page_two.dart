import 'dart:math';

import 'package:flutter/material.dart';

class MyHomePageTwo extends StatefulWidget {
  const MyHomePageTwo({super.key});

  @override
  State<MyHomePageTwo> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageTwo> with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotationAnimation;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    setClockwiseAnimation();
    setFlipAnimation();
    listenToAnimationStatus();
  }

  void setFlipAnimation() {
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );
    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.bounceOut,
      ),
    );
  }

  void listenToAnimationStatus() {
    _counterClockwiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(
            parent: _flipController,
            curve: Curves.bounceOut,
          ),
        );
        _flipController
          ..reset()
          ..forward();
      }
    });
    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseRotationAnimation = Tween<double>(
          begin: _counterClockwiseRotationAnimation.value,
          end: _counterClockwiseRotationAnimation.value - (pi / 2),
        ).animate(
          CurvedAnimation(
            parent: _counterClockwiseRotationController,
            curve: Curves.bounceOut,
          ),
        );

        _counterClockwiseRotationController
          ..reset()
          ..forward.delayed(
            const Duration(
              seconds: 1,
            ),
          );
      }
    });
  }

  void setClockwiseAnimation() {
    _counterClockwiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );
    _counterClockwiseRotationAnimation = Tween<double>(
      begin: 0,
      end: -(pi / 2),
    ).animate(
      CurvedAnimation(
        parent: _counterClockwiseRotationController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _counterClockwiseRotationController.dispose();
    _flipController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(
    //   const Duration(seconds: 1),
    //   () {
    //     _counterClockwiseRotationController
    //       ..reset()
    //       ..forward();
    //   },
    // );

    _counterClockwiseRotationController
      ..reset()
      ..forward.delayed(
        const Duration(
          seconds: 1,
        ),
      );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Animations Day Two"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using border radius
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       height: 200,
            //       width: 100,
            //       decoration: const BoxDecoration(
            //         color: Colors.blue,
            //         borderRadius: BorderRadius.only(
            //           topLeft: Radius.circular(100),
            //           bottomLeft: Radius.circular(100),
            //         ),
            //       ),
            //     ),
            //     Container(
            //       height: 200,
            //       width: 100,
            //       decoration: const BoxDecoration(
            //         color: Colors.yellow,
            //         borderRadius: BorderRadius.only(
            //           topRight: Radius.circular(100),
            //           bottomRight: Radius.circular(100),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            // Using clippers
            AnimatedBuilder(
                animation: _counterClockwiseRotationAnimation,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateZ(
                        _counterClockwiseRotationAnimation.value,
                      ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                            animation: _flipAnimation,
                            builder: (context, child) {
                              return Transform(
                                alignment: Alignment.centerRight,
                                transform: Matrix4.identity()
                                  ..rotateY(
                                    _flipAnimation.value,
                                  ),
                                child: ClipPath(
                                  clipper: HalfCircleClipper(side: CircleSide.left),
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    color: Colors.blue,
                                  ),
                                ),
                              );
                            }),
                        AnimatedBuilder(
                            animation: _flipAnimation,
                            builder: (context, child) {
                              return Transform(
                                alignment: Alignment.centerLeft,
                                transform: Matrix4.identity()
                                  ..rotateY(
                                    _flipAnimation.value,
                                  ),
                                child: ClipPath(
                                  clipper: HalfCircleClipper(side: CircleSide.right),
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    color: Colors.yellow,
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

enum CircleSide {
  left,
  right,
}


extension ToPath on CircleSide {
  Path toPath(Size size) {
    var path = Path();
    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(
          size.width,
          0,
        );
        offset = Offset(
          size.width,
          size.height,
        );
        clockwise = false;
        break;
      case CircleSide.right:
        path.moveTo(
          0,
          0,
        );
        offset = Offset(
          0,
          size.height,
        );
        clockwise = true;
        break;
    }
    path.arcToPoint(
      offset,
      radius: Radius.elliptical(
        size.width / 2,
        size.height / 2,
      ),
      clockwise: clockwise,
    );
    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) {
    return side.toPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

extension on VoidCallback {
  Future delayed(Duration duration) async {
    Future.delayed(
      duration,
      this,
    );
  }
}
