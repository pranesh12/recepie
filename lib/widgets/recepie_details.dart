import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:recepie_app/Model/recipe.dart';
import 'package:recepie_app/provider/favourites_provider.dart';
import 'package:recepie_app/widgets/ingredient_Item.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final int id;
  const RecipeDetailScreen({super.key, required this.id});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  Map<String, dynamic>? recipeDetails;

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails();
  }

  Future<void> fetchRecipeDetails() async {
    try {
      final res = await http
          .get(Uri.parse("https://dummyjson.com/recipes/${widget.id}"));
      if (res.statusCode == 200) {
        setState(() {
          recipeDetails = jsonDecode(res.body);
        });
      } else {
        // Handle server errors
        print("Error fetching recipe details: ${res.statusCode}");
      }
    } catch (e) {
      // Handle network or parsing errors
      print("An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (recipeDetails == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: const Center(
            child: CircularProgressIndicator()), // Loading indicator
      );
    }

    // Safely extract recipe data
    Recipe recipe = Recipe(
      id: recipeDetails!['id'] ?? 0,
      name: recipeDetails!['name'] ?? 'No name available',
      ingredients: List<String>.from(recipeDetails!['ingredients'] ?? []),
      instructions: List<String>.from(recipeDetails!['instructions'] ?? []),
      prepTimeMinutes: recipeDetails!['prepTimeMinutes'] ?? 0,
      cookTimeMinutes: recipeDetails!['cookTimeMinutes'] ?? 0,
      servings: recipeDetails!['servings'] ?? 0,
      difficulty: recipeDetails!['difficulty'] ?? 'Easy',
      cuisine: recipeDetails!['cuisine'] ?? 'Unknown',
      caloriesPerServing: recipeDetails!['caloriesPerServing'] ?? 0,
      tags: List<String>.from(recipeDetails!['tags'] ?? []),
      userId: recipeDetails!['userId'] ?? 0,
      image: recipeDetails!['image'] ?? '',
      rating: (recipeDetails!['rating'] ?? 0).toDouble(),
      reviewCount: recipeDetails!['reviewCount'] ?? 0,
      mealType: List<String>.from(recipeDetails!['mealType'] ?? []),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (ref.read(favoritesProvider.notifier).isFavorite(recipe)) {
                  ref.read(favoritesProvider.notifier).removeFavorite(recipe);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Removed From Favourite")));
                } else {
                  ref.read(favoritesProvider.notifier).addFavorite(recipe);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Row(
                    children: [Text("Added To Favourite ")],
                  )));
                }
              });
            },
            icon: ref.read(favoritesProvider.notifier).isFavorite(recipe)
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.heart_broken,
                    color: Colors.red,
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  recipe.image,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${recipe.prepTimeMinutes + recipe.cookTimeMinutes} minutes',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const CircleAvatar(radius: 14),
                          const SizedBox(width: 8),
                          Text(
                            recipe.cuisine,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            recipe.difficulty,
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 30, color: Colors.grey),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.instructions.join('\n'),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Divider(height: 30, color: Colors.grey),
                  const Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...recipe.ingredients
                      .map<Widget>((i) => IngredientItem(text: i))
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
