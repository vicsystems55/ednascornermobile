import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:tps_mobile/main.dart';
import 'package:tps_mobile/screens/login_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Box box;
  late Box box2;

  List notifications = [];

  String username = '';
  String token = '';
  int wallet_balance = 0;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();

    // print(box.get('token'));
    super.initState();
  }

  // Future openBox() async {

  //   await getUserData();

  //   setState(() {});

  //   return;
  // }

  Future<dynamic> getUserData() async {
    // var dir = await getApplicationDocumentsDirectory();
    // Hive.init(dir.path);
    box = await Hive.openBox('data');
    box2 = await Hive.openBox('data2');

    setState(() {});

    String url = "https://api.phoenixgn.com/api/user_stats";

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // ignore: prefer_interpolation_to_compose_strings
          'Authorization': 'Bearer ' + box.get('token')
        },
      );
      var _jsonDecode = await jsonDecode((response.body));

      // data = _jsonDecode;

      print(_jsonDecode['notifications']);

      await putData(_jsonDecode);
    } catch (SocketException) {
      print(SocketException);
    }

    var mymap2 = box2.toMap().values.toList();
        username = box.get('name');
    wallet_balance = box.get('wallet_balance');
    token = box.get('token');
    if (mymap2 == null) {
      notifications.add('empty');
    } else {
      notifications = mymap2;

      print(notifications);
    }

    // return Future.value(true);
  }

  Future putData(data) async {
    
    await box.put('wallet_balance', data['wallet_balance']);

    username = box.get('name');
    wallet_balance = box.get('wallet_balance');
    token = box.get('token');

    //insert data
    print(data['notifications']);
      await box2.clear();

    for (var d in data['notifications']) {

      box2.add(d);
    }

    print(box2);

    print(box.get('wallet_balance'));

    setState(() {});
  }

  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(
        icon: Icon(Icons.wallet_rounded),
        label: 'Earnings',
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
      const BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_sharp), label: 'Profile'),
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Red(
            // token: box!.get('token')??'',
            // username: box!.get('name')??'',
            // wallet_balance: (box!.get('wallet_balance')??0 / 500).toString()),

            token: token,
            username: username,
            wallet_balance: (wallet_balance / 500).toString(),
            notifications: notifications),
        Blue(),
        Yellow(),
        News(),
        Profile(),
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(22, 29, 49, 1),
        automaticallyImplyLeading: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.notifications),
          )
        ],
        elevation: 0,
        title: Text(widget.title),
      ),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: const TextStyle(color: Colors.white),
        unselectedItemColor: Colors.white54,
        selectedItemColor: const Color.fromRGBO(115, 103, 240, 1),
        backgroundColor: const Color.fromRGBO(22, 29, 49, 1),
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }
}

class Red extends StatefulWidget {
  final String token;
  final String username;
  final String wallet_balance;
  final List notifications;

  const Red(
      {super.key,
      required this.token,
      required this.username,
      required this.wallet_balance,
      required this.notifications});

  @override
  _RedState createState() => _RedState();
}

class _RedState extends State<Red> {
  // String username = widget.username;

  Future<void> updateData() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        color: const Color.fromRGBO(22, 29, 49, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
              child: Text('Welcome ${widget.username}',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 23.0, color: Colors.white)),
            ),
            Container(
              width: double.infinity,
              height: 230.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(40, 48, 70, 1),
                border: Border.all(
                  color: Colors.orange, //                   <--- border color
                  width: 2.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(width: 40, 'assets/images/family_package.png'),
                  const SizedBox(height: 10),
                  new Text(
                      style: TextStyle(color: Colors.white), 'FAMILY PACKAGE'),
                  const SizedBox(height: 15),
                  new Text(
                      style: TextStyle(color: Colors.white54),
                      'CURRENT PACKAGE'),
                  const SizedBox(height: 15),
                  Text(
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold),
                      '\$' + widget.wallet_balance),
                  const SizedBox(height: 15),
                  const Text(
                      style: TextStyle(color: Colors.white54),
                      'WALLET BALANCE'),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              // ignore: prefer_const_constructors
              children: const [Text('Activity Log')],
            ),
            Expanded(
                child: RefreshIndicator(
              onRefresh: updateData,
              child: ListView.builder(
                  itemCount: widget.notifications.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      color: Color.fromARGB(255, 114, 11, 135),
                      child: ListTile(
                        title: Text("${widget.notifications[index]['title']}"),
                        subtitle: Text("${widget.notifications[index]['log']}"),
                        trailing: Icon(Icons.celebration),
                      ),
                    );
                  }),
            ))
          ],
        ));
  }
}

class Blue extends StatefulWidget {
  @override
  _BlueState createState() => _BlueState();
}

class _BlueState extends State<Blue> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(22, 29, 49, 1),
    );
  }
}

class Yellow extends StatefulWidget {
  @override
  _YellowState createState() => _YellowState();
}

class _YellowState extends State<Yellow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(22, 29, 49, 1),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: Card(
                color: const Color.fromRGBO(40, 48, 70, 1),
                child: Column(
                  children: [
                    Image.asset(
                      height: 260,
                      width: double.infinity,
                      'assets/images/1.jpeg',
                      fit: BoxFit.cover,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('BACCARAT ROUGE 540',
                          style: TextStyle(fontSize: 20.0)),
                    ),
                    const Text('5ml, 10ml, 20ml, 30ml, 100ml'),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Text('Place Order'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DashboardPage(
                                      title: '',
                                    )),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: Card(
                color: const Color.fromRGBO(40, 48, 70, 1),
                child: Column(
                  children: [
                    Image.asset(
                      height: 260,
                      width: double.infinity,
                      'assets/images/2.jpeg',
                      fit: BoxFit.cover,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('BLACK K. COLE',
                          style: TextStyle(fontSize: 20.0)),
                    ),
                    const Text('5ml, 10ml, 20ml, 30ml, 100ml'),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Text('Place Order'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DashboardPage(
                                      title: '',
                                    )),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: Card(
                color: const Color.fromRGBO(40, 48, 70, 1),
                child: Column(
                  children: [
                    Image.asset(
                      height: 260,
                      width: double.infinity,
                      'assets/images/3.jpeg',
                      fit: BoxFit.cover,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('DKNY GOLDEN DELICIOUS',
                          style: TextStyle(fontSize: 20.0)),
                    ),
                    const Text('5ml, 10ml, 20ml, 30ml, 100ml'),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Text('Place Order'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DashboardPage(
                                      title: '',
                                    )),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromRGBO(22, 29, 49, 1),
        child: const Center(child: Text('News')));
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Box box;
  late Box box2;

  void logout() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    box2 = await Hive.openBox('data2');

    box.clear();
    box2.clear();

    print('log out');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        color: const Color.fromRGBO(22, 29, 49, 1),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                logout();
              },
              child: Card(
                color: Color.fromRGBO(40, 48, 70, 1),
                elevation: 5,
                child: ListTile(
                  textColor: Colors.white,
                  iconColor: Colors.orange,
                  leading: Icon(Icons.logout),
                  title: Text('Log Out'),
                ),
              ),
            )
          ],
        ));
  }
}
