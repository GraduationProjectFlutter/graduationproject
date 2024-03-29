import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bitirme0/pages/recipe_card.dart';
import 'package:bitirme0/pages/recipeDetailsPage.dart';

class CookifyAI extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cookify AI'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('recipes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('An error has occurred!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No recipes found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> recipeData =
                  document.data()! as Map<String, dynamic>;

              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RecipeDetailsPage(
                      title: recipeData['name'] ?? 'Unnamed Recipe',
                      cookTime: recipeData['duration'] ?? 'Unknown',
                      thumbnailUrl:
                          recipeData['url'] ?? 'assets/images/pizza.png',
                      description: recipeData['description'] ??
                          'No description provided.',
                      difficulty: recipeData['difficulty'] ??
                          'No description provided.',
                      creator:
                          recipeData['addedBy'] ?? 'No description provided.',
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
                      isFavorite: recipeData['isFavorite'] ?? false,
                    ),
                  ));
                },
                child: RecipeCard(
                  title: recipeData['name'] ?? 'Unnamed Recipe',
                  rating: recipeData['rateAverage']?.toString() ?? 'N/A',
                  cookTime: recipeData['duration'] ?? 'Unknown',
                  thumbnailUrl:
                      recipeData['url'] ?? 'assets/default_recipe_image.png',
                  recipeID: recipeData['recipeID'],
                  isFavorite: recipeData['isFavorite'] ?? false,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
