import 'package:flutter/material.dart';
import 'package:recepie_app/widgets/category_card.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  CategoryState createState() => CategoryState();
}

class CategoryState extends State<Category> {
  Future<void> fetchTags() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 3,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        tagName: "Spanish",
                      );
                    }))
          ],
        ));
  }
}
