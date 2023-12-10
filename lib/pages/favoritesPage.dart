import 'package:flutter/material.dart';
import 'package:bitirme0/pages/recipe_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<Recipe> favoriteRecipes = [
    Recipe(
        title: 'Spaghetti Carbonara',
        rating: '4.8',
        cookTime: '20 min',
        thumbnailAsset: 'assets/image/recipe1.png'),
    Recipe(
        title: 'Margherita Pizza',
        rating: '4.7',
        cookTime: '30 min',
        thumbnailAsset: 'assets/image/recipe2.png'),
    Recipe(
        title: 'Classic Caesar Salad',
        rating: '4.5',
        cookTime: '15 min',
        thumbnailAsset: 'assets/image/recipe3.png'),
    Recipe(
        title: 'Grilled Salmon',
        rating: '4.9',
        cookTime: '25 min',
        thumbnailAsset: 'assets/image/recipe4.png'),
    Recipe(
        title: 'Beef Tacos',
        rating: '4.6',
        cookTime: '20 min',
        thumbnailAsset: 'assets/image/recipe5.png'),
  ];

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
          return RecipeCard(
            title: recipe.title,
            rating: recipe.rating,
            cookTime: recipe.cookTime,
            thumbnailAsset: recipe.thumbnailAsset,
          );
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
