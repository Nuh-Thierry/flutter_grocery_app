import 'package:flutter/material.dart';
import 'package:inventory_app/view/allScreens/grocery.dart';
import 'package:inventory_app/view/allScreens/inventary.dart';
import 'package:inventory_app/view/allScreens/shoppingmode.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Title'),
      ),
      body: Center(
        child: Text('Main Content'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                'Tom Swift',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(
                    0xffe5ebe0,
                  ),
                ),
              ),
              accountEmail: Text(
                'tom.swift@gmail.com',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(
                    0xffe5ebe0,
                  ),
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/fridge.png',
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xff191f14),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.inventory),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Inventary',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xff191f14,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InventaryScreen(),
                    ));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.list),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Grocery List',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xff191f14,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroceryScreen(),
                    ));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.shopping_cart),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Shopping Mode',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xff191f14,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShoppingMode(),
                    ));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.analytics),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Analytics',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xff191f14,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Handle the tap
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.schedule),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Schedule',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xff191f14,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Handle the tap
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xff191f14,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Handle the tap
              },
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.info),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xff191f14,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Handle the tap
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xff191f14,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Handle the tap
              },
            ),
          ],
        ),
      ),
    );
  }
}
