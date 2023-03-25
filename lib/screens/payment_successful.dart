import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tps_mobile/screens/dashboard.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://assets6.lottiefiles.com/packages/lf20_47pyyfcf.json',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 30),
            Text(
              'Payment Success!',
              style: TextStyle(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Thanks for your patronage',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(title: ''),
          ));
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
