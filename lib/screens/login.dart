// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:assignment/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const.dart';

class Login extends StatefulWidget {
  static const String login = 'login';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> _handleSignIn() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.id);
        print(user);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: kPrimaryColor,
          content: Text("logged successful"),
        ));
        Navigator.pushReplacementNamed(context, Home.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: kPrimaryColor,
          content: Text("some error occured try again"),
        ));
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 32,
            ),
            const Text(
              'LOGIN',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: SvgPicture.asset(
                'images/login.svg',
                height: 350,
              ),
            ),
            ElevatedButton(
              onPressed: _handleSignIn,
              style: ElevatedButton.styleFrom(primary: kPrimaryColor),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.g_mobiledata,
                    size: 32,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),

      // Center(
      //   child: _user != null
      //       ? Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             CircleAvatar(
      //               radius: 50,
      //               backgroundImage: NetworkImage(_user!.photoUrl ?? ''),
      //             ),
      //             SizedBox(height: 16),
      //             Text('Name: ${_user!.displayName}'),
      //             Text('Email: ${_user!.email}'),
      //             ElevatedButton(
      //               onPressed: () {
      //                 _googleSignIn.signOut();
      //                 setState(() {
      //                   _user = null;
      //                 });
      //               },
      //               child: Text('Sign Out'),
      //             ),
      //           ],
      //         )
      //       : ElevatedButton(
      //           onPressed: _handleSignIn,
      //           style: ElevatedButton.styleFrom(
      //             primary: Colors.red,
      //           ),
      //           child: Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Icon(Icons.g_mobiledata),
      //               SizedBox(width: 8),
      //               Text('Sign in with Google'),
      //             ],
      //           ),
      //         ),
      // ),
    );
  }
}
