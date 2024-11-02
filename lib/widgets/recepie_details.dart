import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
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
        print("Something went wrong");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
              onPressed: () {
                //  ref.read(favoritesProvider.notifier).addFavorite(recipeDetails);
              },
              icon: const Icon(Icons.favorite_border)),
        ],
      ),
      body: recipeDetails == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Image and Back Button
                  Stack(
                    children: [
                      Image.network(
                        recipeDetails?['image'] ?? '',
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 100),
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
                          recipeDetails?['name'] ?? 'No name available',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${(recipeDetails?['prepTimeMinutes'] ?? 0) + (recipeDetails?['cookTimeMinutes'] ?? 0)} minutes',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 14,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  recipeDetails?['cuisine'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  recipeDetails?['difficulty'] ?? 'Easy',
                                  style: const TextStyle(
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
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          (recipeDetails?['instructions'] as List<dynamic>?)
                                  ?.join('\n') ??
                              'No instructions available',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Divider(height: 30, color: Colors.grey[300]),
                        // Ingredients Section
                        const Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...?recipeDetails?['ingredients']
                            ?.map<Widget>((i) => IngredientItem(
                                  text: i.toString(),
                                ))
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
