import 'package:recepie_app/Model/recipe.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  RecipeNotifier() : super([]);

  void setRecipe(List<Recipe> recipes) {
    state = recipes;
  }

  // Method to search recipes by name
  List<Recipe> searchRecipesByName(String name) {
    return state
        .where(
            (recipe) => recipe.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }
}

final recipeProvider =
    StateNotifierProvider<RecipeNotifier, List<Recipe>>((ref) {
  return RecipeNotifier();
});
