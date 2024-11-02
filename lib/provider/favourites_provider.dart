import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recepie_app/Model/recipie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Notifier for managing favorite recipes with local storage
class FavoritesNotifier extends StateNotifier<List<Recipe>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  // Load favorites from local storage
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString('favorites');

    if (favoritesString != null) {
      final List<dynamic> favoritesJson = jsonDecode(favoritesString);
      state = favoritesJson.map((json) => Recipe.fromJson(json)).toList();
    }
  }

  // Add recipe to favorites and save to local storage
  Future<void> addFavorite(Recipe recipe) async {
    if (!state.contains(recipe)) {
      state = [...state, recipe];
      await _saveFavorites();
    }
  }

  // Remove recipe from favorites and save to local storage
  Future<void> removeFavorite(Recipe recipe) async {
    state = state.where((fav) => fav.id != recipe.id).toList();
    await _saveFavorites();
  }

  // Check if a recipe is a favorite
  bool isFavorite(Recipe recipe) {
    return state.any((fav) => fav.id == recipe.id);
  }

  // Save the current favorites list to local storage
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String favoritesString =
        jsonEncode(state.map((recipe) => recipe.toJson()).toList());
    await prefs.setString('favorites', favoritesString);
  }
}

// Provider for FavoritesNotifier
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Recipe>>((ref) {
  return FavoritesNotifier();
});
