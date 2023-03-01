import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as Vector3;

class MyHomePageThree extends StatefulWidget {
  const MyHomePageThree({super.key});

  @override
  State<MyHomePageThree> createState() => _MyHomePageState();
}

const double size = 100;

class _MyHomePageState extends State<MyHomePageThree>
    with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;
  late Tween<double> _animation;

  @override
  void initState() {
    super.initState();
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );
    _animation = Tween<double>(
      begin: 0,
      end: pi * 2,
    );
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();
    _yController
      ..reset()
      ..repeat();
    _zController
      ..reset()
      ..repeat();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animations Day Three"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([
                _xController,
                _yController,
                _zController,
              ]),
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateX(
                      _animation.evaluate(_xController),
                    )
                    ..rotateY(
                      _animation.evaluate(_yController),
                    )
                    ..rotateZ(
                      _animation.evaluate(_zController),
                    ),
                  child: Stack(
                    children: [
                      //Back
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(
                            Vector3.Vector3(0, 0, size),
                          ),
                        child: Container(
                          color: Colors.pink,
                          height: size,
                          width: size,
                        ),
                      ),
                      Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()..rotateY(pi / 2),
                        child: Container(
                          color: Colors.yellow,
                          height: size,
                          width: size,
                        ),
                      ),
                      Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()..rotateY(-pi / 2),
                        child: Container(
                          color: Colors.green,
                          height: size,
                          width: size,
                        ),
                      ),
                      Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()..rotateY(pi / 2),
                        child: Container(
                          color: Colors.yellow,
                          height: size,
                          width: size,
                        ),
                      ),
                      Container(
                        color: Colors.cyan,
                        height: size,
                        width: size,
                      ),
                      Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.identity()..rotateX(-pi / 2),
                        child: Container(
                          color: Colors.yellow,
                          height: size,
                          width: size,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
