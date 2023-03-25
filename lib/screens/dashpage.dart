import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 33, 243, 114), Color.fromARGB(255, 243, 145, 33)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                SizedBox(height: 10.0),
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  _buildMenuItem(context, 'My Orders', Icons.shopping_bag),
                  _buildMenuItem(context, 'Notification', Icons.notifications),
                  _buildMenuItem(context, 'Settings', Icons.settings),
                  _buildMenuItem(context, 'Contact Us', Icons.phone),
                  _buildMenuItem(context, 'Logout', Icons.logout),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon) {
    return InkWell(
      onTap: () {
        // TODO: Implement menu item tap action
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30.0,
              color: Colors.grey[600],
            ),
            SizedBox(width: 20.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
              size: 18.0,
            ),
          ],
        ),
      ),
    );
  }
}
