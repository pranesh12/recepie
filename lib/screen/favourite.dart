import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recepie_app/provider/favourites_provider.dart';

class Favourite extends ConsumerStatefulWidget {
  const Favourite({super.key});

  @override
  FavouriteState createState() => FavouriteState();
}

class FavouriteState extends ConsumerState<Favourite> {
  @override
  Widget build(BuildContext context) {
    final recipes = ref.watch(favoritesProvider);
    return Scaffold(
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Image on the left side
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        recipe.image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Details (name, cooking time, and calories) on the right side
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          // Text("Cooking Time: ${recipe.}"),
                          // SizedBox(height: 4),
                          // Text("Calories: ${recipe.calories} kcal"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
