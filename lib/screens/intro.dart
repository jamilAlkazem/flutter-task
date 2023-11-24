import 'package:assignment/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';
import 'login.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  void initState() {
    checkIfLogged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: kStatusBarColor,
        statusBarIconBrightness: kStatusBarIconColor,
      ),
      child: Scaffold(
        body: Center(
          child: Text('Flutter Task App'),
        ),
      ),
    );
  }

  checkIfLogged() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String? userId = sh.getString('userId');
    Future.delayed(const Duration(milliseconds: 100), () {
      if (userId == null) {
        Navigator.pushReplacementNamed(context, Login.login);
      } else {
        Navigator.pushReplacementNamed(
          context,
          Home.home,
        );
      }
    });
  }
}
