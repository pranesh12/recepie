import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recepie_app/Model/recipie.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int id;
  const RecipeDetailScreen({super.key, required this.id});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
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
        print("Something error happened");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> instructions =
        List<String>.from(recipeDetails?['instructions'] ?? []);

    if (recipeDetails == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image and Back Button
            Stack(
              children: [
                Image.network(
                  recipeDetails?['image'],
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),

            // Recipe Title, Time, and Like Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipeDetails?['name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Food • 60 mins',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                          ),
                          SizedBox(width: 8),
                          Text(
                            recipeDetails?['cuisine'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.favorite, color: Colors.green),
                          Text(
                            '273 Likes',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(height: 30, color: Colors.grey[300]),

                  // Description Section
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your recipe has been uploaded, you can see it on your profile...',
                    style: TextStyle(color: Colors.grey),
                  ),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the start
                    children: [
                      Text(
                        recipeDetails?['instructions'].join(
                            ' '), // Join instructions with a space or use '\n' for new lines
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  Divider(height: 30, color: Colors.grey[300]),

                  // Ingredients Section
                  Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...?recipeDetails?[
                          'ingredients'] // Using spread operator to include items
                      .map<Widget>((i) =>
                          IngredientItem(text: i.toString())) // Use parentheses
                      .toList(),

                  IngredientItem(text: '1/2 Butter'),
                  IngredientItem(text: '1/2 Butter'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientItem extends StatelessWidget {
  final String text;
  IngredientItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: Colors.green),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
