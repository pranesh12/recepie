import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String tagName;
  const CategoryCard({super.key, required this.tagName});

  @override
  CategoryCardState createState() => CategoryCardState();
}

class CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: const Color(0xFF00CC99),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Text(
            widget.tagName,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
