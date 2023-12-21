import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitirme0/pages/recipe_card.dart';
import 'package:bitirme0/pages/recipeDetailsPage.dart'; // RecipeDetailsPage'i import et

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    var userFavoritesRef = _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('favorites');

    var querySnapshot = await userFavoritesRef.get();

    var favoriteRecipeIds = querySnapshot.docs.map((doc) => doc.id).toList();

    var allFavorites = await _firestore
        .collection('recipes')
        .where(FieldPath.documentId, whereIn: favoriteRecipeIds)
        .get();

    setState(() {
      favoriteRecipes = allFavorites.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
      ),
      body: favoriteRecipes.isEmpty
          ? Center(child: Text("You don't have any favorite recipes yet."))
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                var recipe = favoriteRecipes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RecipeDetailsPage(
                        title: recipe['name'],
                        cookTime: recipe['duration'],
                        thumbnailUrl: recipe['url'],
                        description: recipe['description'],
                        difficulty: recipe['difficulty'],
                        creator: recipe['addedBy'],
                        creatorID: recipe['creatorID'],
                        materials: recipe['materials'],
                        recipeID: recipe['recipeID'],
                        category: recipe['category'],
                        calories: recipe['calories'],
                        isFavorite: recipe['isFavorite'],
                      ),
                    ));
                  },
                  child: RecipeCard(
                    title: recipe['name'],
                    rating: recipe['rateAverage'].toString(),
                    cookTime: recipe['duration'],
                    thumbnailUrl: recipe['url'],
                    recipeID: recipe['recipeID'],
                    isFavorite: recipe['isFavorite'] ?? false,
                  ),
                );
              },
            ),
    );
  }
}
