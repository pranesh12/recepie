import 'package:flutter/material.dart';
import 'package:recepie_app/screen/category.dart';
import 'package:recepie_app/screen/favourite.dart';
import 'package:recepie_app/screen/home.dart';

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key});

  @override
  CustomNavbarState createState() => CustomNavbarState();
}

class CustomNavbarState extends State<CustomNavbar> {
  int selectedIdx = 0;

  void _onTaped(int idx) {
    setState(() {
      selectedIdx = idx;
    });
  }

  static List<Widget> pages = [
    const Home(),
    const Favourite(),
    const Category()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: _onTaped,
          currentIndex: selectedIdx,
          selectedItemColor: const Color(0xFF00CC99),
          elevation: 10,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favourites'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Categories')
          ]),
      body: pages.elementAt(selectedIdx),
    );
  }
}
