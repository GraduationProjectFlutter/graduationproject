import 'package:bitirme0/pages/recipeDetailsPage.dart';
import 'package:bitirme0/pages/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class seeAll extends StatefulWidget {
  @override
  _SeeAllState createState() => _SeeAllState();
}

class _SeeAllState extends State<seeAll> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<Map<String, dynamic>> _recipes;

  @override
  void initState() {
    super.initState();
    _recipes = [];
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('recipes').get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _recipes = querySnapshot.docs
              .map((DocumentSnapshot document) =>
                  document.data() as Map<String, dynamic>)
              .toList();
          _recipes.shuffle();
          _recipes = _recipes.take(3).toList();
        });
      }
    } catch (e) {
      print('Error loading recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recommended Recipes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> recipeData = _recipes[index];

          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RecipeDetailsPage(
                  title: recipeData['name'] ?? 'Unnamed Recipe',
                  cookTime: recipeData['duration'] ?? 'Unknown',
                  thumbnailUrl: recipeData['url'] ?? 'assets/images/pizza.png',
                  description:
                      recipeData['description'] ?? 'No description provided.',
                  difficulty:
                      recipeData['difficulty'] ?? 'No description provided.',
                  creator: recipeData['addedBy'] ?? 'No description provided.',
                  creatorID:
                      recipeData['creatorID'] ?? 'No description provided.',
                  materials:
                      recipeData['materials'] ?? 'No description provided.',
                  recipeID:
                      recipeData['recipeID'] ?? 'No description provided.',
                  category:
                      recipeData['category'] ?? 'No description provided.',
                  calories:
                      recipeData['calories'] ?? 'No description provided.',
                ),
              ));
            },
            child: RecipeCard(
              title: recipeData['name'] ?? 'Unnamed Recipe',
              rating: recipeData['rating']?.toString() ?? 'N/A',
              cookTime: recipeData['duration'] ?? 'Unknown',
              thumbnailUrl:
                  recipeData['url'] ?? 'assets/default_recipe_image.png',
            ),
          );
        },
      ),
    );
  }
}
