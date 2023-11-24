// ignore_for_file: use_build_context_synchronously

import 'package:assignment/const.dart';
import 'package:assignment/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/displayData.dart';
import '../screens/login.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late String? id;
  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                if (ModalRoute.of(context)!.settings.name != 'dispalyData') {
                  Navigator.pushNamed(context, DisplayData.dispalyData);
                } else {
                  Navigator.pop(context);
                }
              },
              leading: const Icon(Icons.remove_red_eye),
              title: const Text('show my data'),
            ),
            ListTile(
              onTap: () {
                if (ModalRoute.of(context)!.settings.name != 'home') {
                  Navigator.pushNamed(context, Home.home);
                } else {
                  Navigator.pop(context);
                }
              },
              leading: const Icon(Icons.update),
              title: const Text('update my data'),
            ),
            ListTile(
              onTap: () {
                deleteData();
              },
              leading: const Icon(Icons.delete),
              title: const Text('delete my data'),
              subtitle: const Text('and sign out'),
            )
          ],
        ),
      ),
    );
  }

  getUser() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    id = sh.getString('userId');
  }

  deleteData() async {
    final response = await http.post(
      Uri.parse(deleteDataApi),
      body: {'token': token, 'userId': id},
    );
    if (response.statusCode == 200) {
      if (response.body == 'success') {
        SharedPreferences sh = await SharedPreferences.getInstance();
        await sh.remove('userId');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: kPrimaryColor,
          content: Text("your data deleted successfuly"),
        ));
        Navigator.pushReplacementNamed(context, Login.login);
      } else {}
    }
  }
}
