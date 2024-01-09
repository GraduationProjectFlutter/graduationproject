import 'package:bitirme0/pages/recipeDetailsPage.dart';
import 'package:bitirme0/pages/recipe_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class popularRecipes extends StatefulWidget {
  @override
  _popularRecipes createState() => _popularRecipes();
}

class _popularRecipes extends State<popularRecipes> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<Map<String, dynamic>> _recipes;

  @override
  void initState() {
    super.initState();
    _recipes = [];
    _loadRecipes(); // Sayfa yüklendiğinde tarifleri yükler.
  }

  // Firestore'dan popüler tarifleri yükleyen fonksiyon.
  Future<void> _loadRecipes() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('recipes')
          .orderBy('rateAverage', descending: true)
          .limit(3)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _recipes = querySnapshot.docs
              .map((DocumentSnapshot document) =>
                  document.data() as Map<String, dynamic>)
              .toList();
        });
      }
    } catch (e) {
      print('Error loading recipes: $e');
    }
  }

  // Kullanıcının tarif görüntüleme sayısını artıran fonksiyon.
  void _incrementViewCount(String recipeID) async {
    DocumentReference userClickCountsRef = _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('clickCounts')
        .doc(recipeID);

    await userClickCountsRef.set({
      'recipeID': recipeID,
      'clickCount': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Popular Recipes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false),
      body: ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> recipeData = _recipes[index];

          return InkWell(
            onTap: () {
              _incrementViewCount(recipeData['recipeID']);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RecipeDetailsPage(
                  // Tarif detayları sayfasına yönlendirme.
                  // Tarifin bilgilerini RecipeDetailsPage'a geçiriyoruz.
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
                  isFavorite: recipeData['isFavorite'] ?? false,
                ),
              ));
            },
            child: RecipeCard(
              title: recipeData['name'] ?? 'Unnamed Recipe',
              rating: recipeData['rateAverage'] ?? 'N/A',
              cookTime: recipeData['duration'] ?? 'Unknown',
              thumbnailUrl:
                  recipeData['url'] ?? 'assets/default_recipe_image.png',
              recipeID: recipeData['recipeID'],
              isFavorite: recipeData['isFavorite'] ?? false,
            ),
          );
        },
      ),
    );
  }
}
