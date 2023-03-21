import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Dashpage extends StatefulWidget {
  const Dashpage({super.key});

  @override
  State<Dashpage> createState() => _DashpageState();
}

class _DashpageState extends State<Dashpage> {
  int currentIndex = 0;
  final screens = [
    const Center(
      child: Text('home', style: TextStyle(
        color: Colors.black
      )),
    ),

       Center(
      child: Text('feed', style: TextStyle(
        color: Colors.black
      )),
    ),

       Center(
      child: Text('earnings', style: TextStyle(
        color: Colors.black
      )),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bottom Navigation')),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            currentIndex = index;
            setState(() {});

            print(currentIndex);
          },
          items: [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(
        icon: Icon(Icons.wallet_rounded),
        label: 'Earnings',
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
      const BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_sharp), label: 'Profile'),
          ]),
    );
  }
}
