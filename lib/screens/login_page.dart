import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tps_mobile/screens/dashboard.dart';
import 'package:tps_mobile/screens/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Box box;
  List data = [];

  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openBox();

    // print(box.get('token'));
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future openBox() async {

    try {
      box = await Hive.openBox('data');

    print(box.get('token'));

    if (box.get('token') == null) {
    } else {
        return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const DashboardPage(
                  title: '',
                
                )),
      );
    }
    } catch (e) {
      
    }

  
  }

  Future<dynamic> login() async {
    setState(() {
      isLoading = true;
    });

    await openBox();

    String url = "https://ecomm.vicsystems.com.ng/api/v1/login";

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': emailController.text,
          'password': passwordController.text
        }),
      );
      var _jsonDecode = jsonDecode((response.body));

      // data = _jsonDecode;
      print(_jsonDecode);

      await putData(_jsonDecode);
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

  Future putData(data) async {
    await box.clear();

    box.put('token', data['access_token']);

    box.put('name', data['user_data']['name']);

    box.put('email', data['user_data']['email']);


    //insert data
    // for (var d in data) {
    //   box.add(data);
    // }

    print(box.get('token'));

    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const DashboardPage(
                title: '',
              )),
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Welcome back',
                    style: TextStyle(fontSize: 20),
                  )),
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
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                   autofillHints: const [AutofillHints.password],
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text(
                  'Forgot Password',
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
                        : const Text('Login'),
                    onPressed: () {
                       TextInput.finishAutofillContext();
                      print(emailController.text);
                      print(passwordController.text);
    
                      login();
    
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const DashboardPage(
                      //             title: '',
                      //           )),
                      // );
                    },
                  )),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Does not have account?'),
                  TextButton(
                    child: const Text(
                      'Sign up',
                      
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
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
