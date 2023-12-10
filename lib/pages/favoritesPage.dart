import 'package:flutter/material.dart';
import 'package:bitirme0/pages/recipe_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<Recipe> favoriteRecipes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoriteRecipes.length,
        itemBuilder: (context, index) {
          final recipe = favoriteRecipes[index];
        },
      ),
    );
  }
}

class Recipe {
  final String title;
  final String rating;
  final String cookTime;
  final String thumbnailAsset;

  Recipe({
    required this.title,
    required this.rating,
    required this.cookTime,
    required this.thumbnailAsset,
  });
}
