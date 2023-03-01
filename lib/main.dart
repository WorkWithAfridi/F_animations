
import 'dart:developer';

import 'package:f_animations/screens/page_three.dart';
import 'package:f_animations/screens/page_two.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    log("Building");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePageThree(),
    );
  }
}
