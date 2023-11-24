import 'package:assignment/screens/displayData.dart';
import 'package:assignment/screens/home.dart';
import 'package:assignment/screens/login.dart';
import 'package:flutter/material.dart';
// ...

import 'screens/intro.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Task',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Intro(),
        Login.login: (context) => const Login(),
        Home.home: (context) => const Home(),
        DisplayData.dispalyData: (context) => const DisplayData(),
      },
    );
  }
}
