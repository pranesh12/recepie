import 'package:recepie_app/Model/recipie.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  RecipeNotifier() : super([]);

  void setRecipie(List<Recipe> recipies) {
    state = recipies;
  }

  List<Recipe> searchRecipe(String query) {
    return state
        .where(
            (recipe) => recipe.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

final recipeProvider =
    StateNotifierProvider<RecipeNotifier, List<Recipe>>((ref) {
  return RecipeNotifier();
});
