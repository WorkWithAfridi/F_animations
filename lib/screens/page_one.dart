import 'dart:math';

import 'package:flutter/material.dart';

class MyHomePageOne extends StatefulWidget {
  const MyHomePageOne({super.key});

  @override
  State<MyHomePageOne> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageOne> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_animationController);

    _animationController.repeat(
        // reverse: true,
        );

    _animationController.stop();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animations Day One"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  // origin: const Offset(100, 100),
                  transform: Matrix4.identity()
                    ..rotateZ(
                      _animation.value,
                    ),
                  // ..rotateX(
                  //   _animation.value,
                  // )
                  // ..rotateY(
                  //   _animation.value,
                  // ),
                  child: Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.cyan,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.5),
                          spreadRadius: 10,
                          blurRadius: 15,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: const Text(
                      "Hello world!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () {
                _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_animationController);
                _animationController.repeat(
                    // reverse: true,
                    );
              },
              child: const Text(
                "Start",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _animationController.stop();
              },
              child: const Text(
                "Stop",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
