import 'package:flutter/material.dart';
import 'package:tps_mobile/main.dart';
import 'package:tps_mobile/screens/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dashboard.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<dynamic> register() async {

    print('starts here');
    setState(() {
      isLoading = true;
    });

    String url = "https://ecomm.vicsystems.com.ng/api/v1/register";

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': emailController.text,
          'name': nameController.text,
          'password': passwordController.text
        }),
      );
      var _jsonDecode = jsonDecode((response.body));

      // data = _jsonDecode;
      print(_jsonDecode);

      setState(() {
        isLoading = false;
      });

      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const DashboardPage(
                  title: '',
                )),
      );
    } catch (SocketException) {
      setState(() {
        isLoading = false;
      });
      print(SocketException);
    }

    // var mymap = box.toMap().values.toList();
    // if (mymap == null) {
    //   data.add('empty');
    // } else {
    //   data = mymap;

    //   print(data);
    // }

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                height: 150.0,
                width: 190.0,
                padding: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Center(
                  child: Image.asset(width: 210, 'assets/images/launcher.png'),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Fullname',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  obscureText: true,
             
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Register.'),
                    onPressed: () {
                      print(nameController.text);
                      print(emailController.text);
                      print(passwordController.text);

                        register();

                    },
                  )),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have account?'),
                  TextButton(
                    child: const Text(
                      'Sign In',
                      
                    ),
                    onPressed: () {
                      //signup screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    },
                  )
                ],
              ),
            ],
          )),
    );
  }
}
