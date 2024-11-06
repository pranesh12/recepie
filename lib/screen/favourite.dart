import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe_app/provider/favourites_provider.dart';
import 'package:recipe_app/widgets/recipe_details.dart';

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
      appBar: AppBar(
        title: const Text("Wishlist"),
        toolbarHeight: 80,
      ),
      body: recipes.isEmpty
          ? const Center(
              child: Text(
                "No Favourite Recipe",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Dismissible(
                  key: Key(recipe.name),
                  onDismissed: (DismissDirection direction) {
                    setState(() {
                      ref
                          .read(favoritesProvider.notifier)
                          .removeFavorite(recipe);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text("Recipe has been removed"),
                        action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              ref
                                  .read(favoritesProvider.notifier)
                                  .addFavorite(recipe);
                            }),
                      ));
                    });
                  },
                  background: Container(
                    color: Colors.red, // Background color when swiped
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(
                            id: recipe.id,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      elevation: 4,
                      child: SizedBox(
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Row(
                            children: [
                              // Image on the left side
                              Flexible(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1),
                                  child: Image.network(
                                    recipe.image,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
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
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.timelapse_outlined,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          "${recipe.cookTimeMinutes + recipe.prepTimeMinutes} minutes",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.local_fire_department,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          "${recipe.caloriesPerServing} cal",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
