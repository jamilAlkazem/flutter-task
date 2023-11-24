// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:assignment/screens/displayData.dart';
import 'package:assignment/screens/login.dart';
import 'package:assignment/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';

class Home extends StatefulWidget {
  static const String home = 'home';

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;
  List validate = [true, true, true, true, true, true];
  late Future<String> emailIsTaken;
  bool isChecking = false;
  bool loading = true;
  String? id;
  Map values = {
    'username': '',
    'email': '',
    'phone': '',
    'birthday': '',
    'address': '',
  };
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final birthday = TextEditingController();
  final address = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    birthday.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
    emailIsTaken = emailCheck('');
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
            SingleChildScrollView(
              child: Column(
                children: [
                  textfeild('Name', 'username', name, validateUsername),
                  textfeild('Email', 'email', email, validateEmail),
                  FutureBuilder<String>(
                    future: emailIsTaken,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == 'emailNotExist') {
                          validate[5] = true;
                          return Container();
                        } else {
                          validate[5] = false;
                          return Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: Text(
                              snapshot.data!,
                              style: TextStyle(color: Colors.red[800], fontSize: 12),
                            ),
                          );
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  textfeild('Phone Number', 'phone', phone, validatePhone),
                  textfeild('Birthday', 'birthday', birthday, validateBirthday),
                  textfeild('Address', 'address', address, validateAddress),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            autovalidateMode = AutovalidateMode.always;
                          });

                          if (validate[0] &&
                              values['username'] != '' &&
                              validate[1] &&
                              values['email'] != '' &&
                              validate[2] &&
                              values['phone'] != '' &&
                              validate[3] &&
                              values['birthday'] != '' &&
                              validate[4] &&
                              values['address'] != '' &&
                              validate[5] &&
                              !isChecking) {
                            setState(() {
                              loading = true;
                            });
                            final response = await http.post(
                              Uri.parse(saveData),
                              body: {
                                'name': values['username'],
                                'email': values['email'],
                                'phone': values['phone'],
                                'birthday': values['birthday'],
                                'address': values['address'],
                                'token': token,
                                'userId': id,
                              },
                            ).catchError((error) {
                              setState(() {
                                loading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                backgroundColor: kPrimaryColor,
                                content: Text("connection lost"),
                              ));
                            });
                            if (response.statusCode == 200) {
                              setState(() {
                                loading = false;
                              });
                              Map x = json.decode(response.body);
                              if (x['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  backgroundColor: kPrimaryColor,
                                  content: Text("data saved"),
                                ));
                                FocusScope.of(context).requestFocus(FocusNode());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("some thing wrong try again"),
                                ));
                              }
                            } else {
                              setState(() {
                                loading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("some thing wrong try again"),
                              ));
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: kPrimaryColor,
                            border: Border.all(),
                          ),
                          width: double.infinity,
                          height: 48,
                          child: const Center(
                              child: Text(
                            'save data',
                            style: TextStyle(color: kTextLightBodyColor, fontWeight: FontWeight.bold),
                          )),
                        ),
                      )),
                ],
              ),
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

  Padding textfeild(String text, String type, TextEditingController controller, Function(String?) validate) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '* $text',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Form(
            autovalidateMode: autovalidateMode,
            child: TextFormField(
              controller: controller,
              validator: ((value) {
                return validate(value);
              }),
              decoration: InputDecoration(
                isDense: true, // Added this
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: type == 'birthday'
                    ? IconButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                            birthday.text = formattedDate;
                            values['birthday'] = formattedDate;
                          }
                        },
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Colors.black,
                        ))
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: const BorderSide(width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: const BorderSide(width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: const BorderSide(width: 2),
                ),
                hintText: text,
                hintStyle: const TextStyle(fontSize: 14),
              ),
              onChanged: (value) {
                if (type == 'email') {
                  setState(() {
                    isChecking = true;
                    emailIsTaken = emailCheck(value);
                  });
                }
                values[type] = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  String? validateEmail(String? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      validate[1] = false;
      return 'enter valid email';
    } else {
      validate[1] = true;
      return null;
    }
  }

  String? validateUsername(String? value) {
    if (value!.length < 4) {
      validate[0] = false;
      return '* username must between 4-20 charecter';
    } else {
      validate[0] = true;
      return null;
    }
  }

  String? validatePhone(String? value) {
    final phoneNumberRegex = RegExp(r'^\+?\d{1,4}?[-. ]?\(?\d{1,3}?\)?[-. ]?\d{1,4}[-. ]?\d{1,9}$');

    if (!phoneNumberRegex.hasMatch(value!)) {
      validate[2] = false;
      return 'enter valid phoneNumber';
    } else {
      validate[2] = true;
      return null;
    }
  }

  String? validateBirthday(String? value) {
    String pattern = r'^(3[01]|[12][0-9]|0?[1-9])(\/|-)(1[0-2]|0?[1-9])\2([0-9]{2})?[0-9]{2}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      validate[3] = false;
      return '* Birthday not valid';
    } else {
      validate[3] = true;
      return null;
    }
  }

  String? validateAddress(String? value) {
    if (value == null || value == '') {
      validate[4] = false;
      return 'Address is required';
    } else {
      validate[4] = true;
      return null;
    }
  }

  Future<String> emailCheck(String value) async {
    if (value == '') {
      validate[5] = true;
      isChecking = false;
      return 'emailNotExist';
    } else {
      final response = await http.post(
        Uri.parse(checkEmail),
        body: {
          'email': value,
          'userId': id,
        },
      );
      if (response.statusCode == 200) {
        isChecking = false;
        String x = response.body;
        return x;
      } else {
        isChecking = false;
        return '* connection lost';
      }
    }
  }

  getData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    id = sh.getString('userId');
    final response = await http.post(
      Uri.parse(getdataApi),
      body: {'token': token, 'userId': id},
    );
    if (response.statusCode == 200) {
      setState(() {
        name.text = (json.decode(response.body))['name'];
        email.text = (json.decode(response.body))['email'];
        phone.text = (json.decode(response.body))['phone'];
        birthday.text = (json.decode(response.body))['birthday'];
        address.text = (json.decode(response.body))['address'];
        values['username'] = (json.decode(response.body))['name'];
        values['email'] = (json.decode(response.body))['email'];
        values['phone'] = (json.decode(response.body))['phone'];
        values['birthday'] = (json.decode(response.body))['birthday'];
        values['address'] = (json.decode(response.body))['address'];
        loading = false;
      });
    }
  }
}
