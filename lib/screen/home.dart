import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe_app/Model/recipe.dart';
import 'package:recipe_app/constant/api_endpoint.dart';
import 'package:recipe_app/constant/country.dart';
import 'package:recipe_app/provider/recipe_provider.dart';
import 'package:recipe_app/widgets/recipe_details.dart';
import 'package:recipe_app/widgets/recipe_card.dart';
import 'package:http/http.dart' as http;

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  String searchItem = "";
  bool isLoading = true;
  List<String> cuisines = Country.cuisines;

  @override
  void initState() {
    super.initState();
    fetchRecipe();
  }

  Future<void> fetchRecipe() async {
    try {
      final response = await http.get(Uri.parse(ApiEndpoint.baseUrl));

      if (response.statusCode == 200) {
        List<Recipe> recipes = (jsonDecode(response.body)['recipes'] as List)
            .map((recipeData) => Recipe.fromJson(recipeData))
            .toList();
        ref.read(recipeProvider.notifier).setRecipe(recipes);
      } else {
        // Log the response in case of failure
        debugPrint("Failed to fetch recipes: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching recipes: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipes = ref.watch(recipeProvider);
    final filterRecipes = searchItem.isEmpty
        ? recipes
        : ref.read(recipeProvider.notifier).searchRecipesByName(searchItem);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF00CC99),
        title: const Text(
          "Welcome to Foodie",
          style: TextStyle(color: Colors.white),
        ),
        toolbarHeight: 60,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchItem = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search recipes...',
                    suffixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                  ),
                ),

                // Recipe Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.90,
                    ),
                    itemCount: filterRecipes.length,
                    itemBuilder: (context, index) {
                      Recipe recipe = filterRecipes[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(
                                id: recipe.id,
                              ),
                            ),
                          );
                        },
                        child: RecipeCard(
                          id: recipe.id,
                          imageUrl: recipe.image,
                          title: recipe.name,
                          duration:
                              '${recipe.prepTimeMinutes + recipe.cookTimeMinutes} min',
                          calories: '${recipe.caloriesPerServing} Cal',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
