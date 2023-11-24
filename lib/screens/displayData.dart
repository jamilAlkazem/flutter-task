import 'dart:convert';

import 'package:assignment/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../const.dart';

class DisplayData extends StatefulWidget {
  static const String dispalyData = 'dispalyData';

  const DisplayData({super.key});

  @override
  State<DisplayData> createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  bool loading = true;

  late String? id;

  String name = '';

  String email = '';

  String phone = '';

  String birthday = '';

  String address = '';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: kStatusBarColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        title: const Text('task'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'My Data',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                feild('name', name),
                feild('email', email),
                feild('phone', phone),
                feild('birthday', birthday),
                feild('address', address),
                const Spacer(),
                const Spacer(),
                const Spacer(),
              ],
            ),
            if (loading)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: kLoaderBackground,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget feild(String text, String value) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              '$text :',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  getData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    id = sh.getString('userId');
    final response = await http.post(
      Uri.parse(getdataApi),
      body: {'token': token, 'userId': id},
    );
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        name = (json.decode(response.body))['name'];
        email = (json.decode(response.body))['email'];
        phone = (json.decode(response.body))['phone'];
        birthday = (json.decode(response.body))['birthday'];
        address = (json.decode(response.body))['address'];
        loading = false;
      });
    }
  }
}
