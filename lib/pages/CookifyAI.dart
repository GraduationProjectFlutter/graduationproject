import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bitirme0/pages/recipe_card.dart';
import 'package:bitirme0/pages/recipeDetailsPage.dart'; // RecipeDetailsPage'i import et

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
                      rating: recipeData['rating']?.toString() ?? 'N/A',
                      cookTime: recipeData['duration'] ?? 'Unknown',
                      thumbnailAsset:
                          recipeData['image'] ?? 'assets/images/pizza.png',
                      description: recipeData['description'] ??
                          'No description provided.',
                    ),
                  ));
                },
                child: RecipeCard(
                  title: recipeData['name'] ?? 'Unnamed Recipe',
                  rating: recipeData['rating']?.toString() ?? 'N/A',
                  cookTime: recipeData['duration'] ?? 'Unknown',
                  thumbnailAsset:
                      recipeData['image'] ?? 'assets/default_recipe_image.png',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
