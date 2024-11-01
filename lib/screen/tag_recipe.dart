import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recepie_app/constant/api_endpoint.dart';
import 'package:recepie_app/Model/recipie.dart';
import 'package:recepie_app/widgets/recipe_card.dart';

class TagRecipe extends StatefulWidget {
  final String tagName;
  const TagRecipe({super.key, required this.tagName});

  @override
  TagRecipeState createState() => TagRecipeState();
}

class TagRecipeState extends State<TagRecipe> {
  List<Recipe> recipes = [];
  bool isLoading = true;

  @override
  initState() {
    super.initState();

    setState(() {
      getRecipeByTagName();
    });
  }

  Future<void> getRecipeByTagName() async {
    try {
      final res = await http
          .get(Uri.parse("${ApiEndpoint.baseUrl}/tag/${widget.tagName}"));

      if (res.statusCode == 200) {
        setState(() {
          final data = jsonDecode(res.body);
          recipes = (data['recipes'] as List)
              .map((recipe) => Recipe.fromJson(recipe))
              .toList();

          isLoading = false;
        });
      } else {
        print("something went wrong");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tagName),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
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
