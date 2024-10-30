import 'package:flutter/material.dart';
import 'package:recepie_app/widgets/recipe_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Search recipes...',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey,
            contentPadding: EdgeInsets.all(8),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Wrap(
              spacing: 8.0,
              children: [
                Chip(
                  label: Text('Cook Now'),
                  backgroundColor: Colors.green.shade100,
                ),
                Chip(
                  label: Text('Breakfast'),
                  backgroundColor: Colors.green.shade100,
                ),
                Chip(
                  label: Text('Low Price'),
                  backgroundColor: Colors.green.shade100,
                ),
              ],
            ),
          ),

          // Grid View
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.75,
              ),
              itemCount: 6, // Replace with your dynamic item count
              itemBuilder: (context, index) {
                return RecipeCard(
                  imageUrl:
                      'https://via.placeholder.com/150', // Placeholder image URL
                  title: 'Recipe Title $index',
                  duration: '40 min',
                  calories: '${200 + (index * 50)} Cal',
                  favoriteCount: '${5 + index}',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
