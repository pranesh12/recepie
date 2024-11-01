import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recepie_app/Model/recipie.dart';
import 'package:recepie_app/constant/api_endpoint.dart';
import 'package:recepie_app/provider/recipe_provider.dart';
import 'package:recepie_app/widgets/recipe_card.dart';
import 'package:http/http.dart' as http;

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchRecipe();
  }

  Future<void> fetchRecipe() async {
    try {
      final response = await http.get(Uri.parse(ApiEndpoint.baseUrl));

      if (response.statusCode == 200) {
        setState(() {
          List<Recipe> recipes = (jsonDecode(response.body)['recipes'] as List)
              .map((recipeData) => Recipe.fromJson(recipeData))
              .toList();
          ref.read(recipeProvider.notifier).setRecipie(recipes);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipes = ref.watch(recipeProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF00CC99),
        title: const Text(
          "Welcome to Foodie",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:
          // Loading indicator
          Column(
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
                childAspectRatio: 0.90,
              ),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                Recipe recipe = recipes[index];
                return RecipeCard(
                  id: recipe.id,
                  imageUrl: recipe.image,
                  title: recipe.name,
                  duration:
                      '${recipe.prepTimeMinutes + recipe.cookTimeMinutes} min',
                  calories: '${recipe.caloriesPerServing} Cal',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
