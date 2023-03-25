import 'package:flutter/material.dart';
import 'package:tps_mobile/screens/dashboard.dart';
import 'package:tps_mobile/screens/login_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      title: 'Ednascorner',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(
              color: Color.fromARGB(137, 85, 85, 85), //<-- SEE HERE
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black54),
            ),
          ),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Color.fromARGB(255, 0, 0, 0), //<-- SEE HERE
                displayColor: Color.fromARGB(255, 0, 0, 0), //<-- SEE HERE
              ),
          primarySwatch: Colors.brown),
      home: const MyHomePage(title: 'Ednascorner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box box;

  bool isLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openBox();

    // print(box.get('token'));
  }

  Future<bool> openBox() async {
    box = await Hive.openBox('data');

    print(box.get('token'));

    if (box.get('token') != null) {
      isLoggedIn = true;
    }

    return isLoggedIn;
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Color.fromRGBO(22, 29, 49, 1),
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      // body: isLoggedIn?DashboardPage(title: ''):LoginScreen(),
      body: FutureBuilder<bool>(
        future: openBox(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the network call is in progress, display a loading spinner
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            // If an error occurred during the network call, display an error message
            return LoadingScreen();
          } else {
            if(snapshot.data == true){
            return DashboardPage(title: '',);

            }else{
               return const LoginScreen();
            }
            // If the network call was successful, display the data

           
          }
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
