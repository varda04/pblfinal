import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'cartPage.dart';
import 'internalHomePage.dart';
import 'package:pblfinal/menuPage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages= [
    const InternalHomePage(),
     MenuPage(),
     CartPage(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("QuickByte"),
        backgroundColor: Colors.pink,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar:
          CurvedNavigationBar(backgroundColor: Colors.deepPurple,color: Colors.deepPurple.shade200,onTap: (index){
            setState(() {
              _currentIndex=index;
            });
          }, items: const [
            Icon(Icons.home),
            Icon(Icons.list),
            Icon(Icons.shopping_cart),
            //probably just implement this using uihelper too???
        // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        // BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Menu'),
        // BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart')
      ]),
    );
  }
}
