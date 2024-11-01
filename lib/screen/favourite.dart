import 'package:flutter/material.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  FavouriteState createState() => FavouriteState();
}

class FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite"),
      ),
      body: Center(
        child: Text("Favourite"),
      ),
    );
  }
}
