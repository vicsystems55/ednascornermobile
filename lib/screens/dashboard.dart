// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:tps_mobile/main.dart';
import 'package:tps_mobile/screens/login_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:tps_mobile/screens/payment_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DashboardPage extends StatefulWidget {
  method() => createState().generateInvoiceCode();

  const DashboardPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Box box;
  late Box box2;
  late Box box3;

  List products = [];

  List invoiceData = [];

  String username = '';
  String token = '';
  int wallet_balance = 0;

  int cartCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    getProducts();
    generateInvoiceCode();

    // print(box.get('token'));
    super.initState();
  }

  // Future openBox() async {

  //   await getUserData();

  //   setState(() {});

  //   return;
  // }

  Future<dynamic> generateInvoiceCode() async {
    box = await Hive.openBox('data');
    box3 = await Hive.openBox('invoiceData');

    setState(() {});

    if (box.get('invoiceCode') == null) {
      print('no invoice');
      box.put(
          'invoiceCode', (DateTime.now().millisecondsSinceEpoch).toString());
      print(box.get('invoiceCode'));

      String url = "https://ecomm.vicsystems.com.ng/api/v1/invoices";

      try {
        var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + box.get('token')
          },
          body: jsonEncode(<String, String>{
            'invoice_code': (box.get('invoiceCode')).toString()
          }),
        );
        var _jsonDecode = jsonDecode((response.body));

        // data = _jsonDecode;
        print(box.get('invoiceCode'));
      } catch (SocketException) {
        print(SocketException);
      }
    } else {
      // setState(() {});

      String url = "https://ecomm.vicsystems.com.ng/api/v1/invoices";

      try {
        final queryParameters = {
          'invoice_code': (box.get('invoiceCode')).toString(),
        };

        final uri = Uri.https(
            'ecomm.vicsystems.com.ng',
            '/api/v1/invoices/' + (box.get('invoiceCode')).toString(),
            queryParameters);

        var response = await http.get(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + box.get('token')
          },
        );

        var _jsonDecode = jsonDecode((response.body));
        print(_jsonDecode);

        await putInvoiceData(_jsonDecode);

        // data = _jsonDecode;
      } catch (SocketException) {
        print(SocketException);
      }

      var _invoiceData = box3.toMap().values.toList();

      // box3.put('cartCount', _invoiceData.length);

      if (_invoiceData == null) {
        invoiceData.add('empty');
      } else {
        print('something');

        invoiceData = _invoiceData;

        // cartCount = invoiceData.length;

        return invoiceData;
      }
    }
  }

  Future putInvoiceData(data) async {
    //insert data
    // print(data['invoice_items']);

    await box3.clear();

    for (var d in data['invoice_items']) {
      box3.add(d);
      // print('yes invoiceData');
    }

    // print(box3);

    // super.initState();

    setState(() {});
  }

  Future<dynamic> getProducts() async {
    // var dir = await getApplicationDocumentsDirectory();
    // Hive.init(dir.path);
    box = await Hive.openBox('data');
    box2 = await Hive.openBox('data2');

    setState(() {});

    String url = "https://ecomm.vicsystems.com.ng/api/v1/products";

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // ignore: prefer_interpolation_to_compose_strings
          'Authorization': 'Bearer ' + box.get('token')
        },
      );
      print('got products');
      var _jsonDecode = await jsonDecode((response.body));

      // data = _jsonDecode;

      // print(_jsonDecode);

      await putData(_jsonDecode);
    } catch (SocketException) {
      print(SocketException);
    }

    var mymap2 = box2.toMap().values.toList();
    username = box.get('name');

    token = box.get('token');

    if (mymap2 == null) {
      products.add('empty');
    } else {
      products = mymap2;

      print(products);
    }

    // return Future.value(true);
  }

  Future putData(data) async {
    username = box.get('name');
    token = box.get('token');

    //insert data
    print(data);
    await box2.clear();

    for (var d in data) {
      box2.add(d);
    }

    print(box2);

    setState(() {});
  }

  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      // const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

      const BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
      BottomNavigationBarItem(
          icon: badges.Badge(
            badgeContent: Text(cartCount.toString()),
            child: Icon(Icons.shopping_cart),
          ),
          label: 'Cart'),
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
            products: products),
        Blue(),
        Profile(),
        Yellow(),
        News(),
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
        selectedItemColor: Colors.brown,
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
  final List products;

  const Red(
      {super.key,
      required this.token,
      required this.username,
      required this.products});

  @override
  _RedState createState() => _RedState();
}

class _RedState extends State<Red> {
  // String username = widget.username;

  late Box box2;
  late Box box;

  List products = [];

  Future<void> updateData() async {
    box2 = await Hive.openBox('data2');
    box = await Hive.openBox('data');

    print(box.get('invoiceCode'));

    var mymap2 = box2.toMap().values.toList();

    if (mymap2 == null) {
      products.add('empty');
    } else {
      products = mymap2;

      print(products);
    }
  }

  Future<dynamic> addToCart(productId) async {
    // var dir = await getApplicationDocumentsDirectory();
    // Hive.init(dir.path);

    box = await Hive.openBox('data');
    // box2 = await Hive.openBox('data2');

    print(box.get('invoiceCode'));

    String url = "https://ecomm.vicsystems.com.ng/api/v1/invoice-lines";

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // ignore: prefer_interpolation_to_compose_strings
          'Authorization': 'Bearer ' + box.get('token')
        },
        body: jsonEncode(<dynamic, dynamic>{
          'invoice_code': box.get('invoiceCode'),
          'product_id': productId
        }),
      );
      // var _jsonDecode = await jsonDecode((response.body));

      // data = _jsonDecode;

      print(response.body);

      Flushbar(
        title: 'Hey awesome!!',
        message: 'Product added to cart!!',
        duration: Duration(seconds: 3),
      ).show(context);

      const DashboardPage(
        title: '',
      ).method();

      // await putData(_jsonDecode);
    } catch (SocketException) {
      print(SocketException);
    }

    // return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
              child: Text('Welcome ${widget.username}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 23.0,
                  )),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              // ignore: prefer_const_constructors
              children: const [Text('Shop')],
            ),
            Expanded(
                child: RefreshIndicator(
              onRefresh: updateData,
              child: ListView.builder(
                  itemCount: widget.products.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: "${widget.products[index]['img_url']}",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("${widget.products[index]['name']}",
                                style: TextStyle(fontSize: 20.0)),
                          ),
                          Text("${widget.products[index]['price']}"),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text('Add to cart'),
                                  Icon(Icons.add_shopping_cart)
                                ],
                              ),
                              onPressed: () {
                                addToCart(widget.products[index]['id']);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const DashboardPage(
                                //             title: '',
                                //           )),
                                // );
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ))
          ],
        ));
  }
}

class Blue extends StatefulWidget {
  const Blue();
  @override
  _BlueState createState() => _BlueState();
}

class _BlueState extends State<Blue> {
  late Box box;
  late Box box2;
  late Box box3;
  List invoiceData = [];
  int totalAmount = 0;
  final String paymentUrl = '';

  void initState() {
    // TODO: implement initState
    generateInvoiceCode();
    super.initState();
  }

  Future<dynamic> generateInvoiceCode() async {
    box = await Hive.openBox('data');
    box3 = await Hive.openBox('invoiceData');

    setState(() {});

    if (box.get('invoiceCode') == null) {
    } else {
      // setState(() {});

      String url = "https://ecomm.vicsystems.com.ng/api/v1/invoices";

      try {
        final queryParameters = {
          'invoice_code': (box.get('invoiceCode')).toString(),
        };

        final uri = Uri.https(
            'ecomm.vicsystems.com.ng',
            '/api/v1/invoices/' + (box.get('invoiceCode')).toString(),
            queryParameters);

        var response = await http.get(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + box.get('token')
          },
        );

        var _jsonDecode = jsonDecode((response.body));
        print(_jsonDecode);

        await putInvoiceData(_jsonDecode);

        // data = _jsonDecode;
      } catch (SocketException) {
        print(SocketException);
      }

      var _invoiceData = box3.toMap().values.toList();

      // box3.put('cartCount', _invoiceData.length);

      if (_invoiceData == null) {
        invoiceData.add('empty');
      } else {
        print('something');

        invoiceData = _invoiceData;

        totalAmount = int.parse(box.get('totalAmount'));

        // cartCount = invoiceData.length;

        // return invoiceData;
      }
    }
  }

  Future putInvoiceData(data) async {
    //insert data
    // print(data['invoice_items']);

    await box3.clear();

    for (var d in data['invoice_items']) {
      box3.add(d);
      // print('yes invoiceData');
    }

    box.put('totalAmount', data['total_amount']);

    // print(box3);

    // super.initState();

    setState(() {});
  }

  Future<dynamic> updateData() async {
    print(invoiceData);
    return invoiceData;
  }

  Future<dynamic> initiatePayment() async {
    String url = "https://api.paystack.co/transaction/initialize";

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer sk_test_a7d9fda24fbf7c438446f86671d8a4fcb78be8ec'
        },
        body: jsonEncode(<dynamic, dynamic>{
          'email': box.get('email'),
          'amount': totalAmount * 100,
          'callback_url':
              "https://ecomm.vicsystems.com.ng/api/v1/mobile-product-order?email=${box.get('email')}&invoiceCode=${box.get('invoiceCode')}&address='Nigeria'"
        }),
      );
      var _jsonDecode = jsonDecode((response.body));

      // data = _jsonDecode;
      print(_jsonDecode['data']['authorization_url']);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewApp(
                paymentUrl: _jsonDecode['data']['authorization_url'])),
      );
    } catch (SocketException) {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              height: 500,
              child: RefreshIndicator(
                onRefresh: updateData,
                child: ListView.builder(
                    itemCount: invoiceData.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        child: Container(
                          height: 90,
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    "${invoiceData[index]['products']['img_url']}",
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              Text("${invoiceData[index]['products']['name']}"),
                            ],
                          ),
                        ),
                      );
                    }),
              )),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Proceed to Payment'),
                onPressed: () {
                  initiatePayment();
                },
              ))
        ],
      ),
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
    return Container(child: const Center(child: Text('News')));
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

    await box.clear();
    await box2.clear();

    print('log out');

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
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
