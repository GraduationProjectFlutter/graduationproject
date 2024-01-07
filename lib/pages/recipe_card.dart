import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeCard extends StatefulWidget {
  final String title;
  final String rating;
  final String cookTime;
  final String thumbnailUrl;
  final String recipeID;
  bool isFavorite;
  bool containsDiseaseIngredient;

  RecipeCard({
    Key? key,
    required this.title,
    required this.cookTime,
    required this.rating,
    required this.thumbnailUrl,
    required this.recipeID,
    required this.isFavorite,
    this.containsDiseaseIngredient = false,
  }) : super(key: key);

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int clickCount = 0;
  @override
  void initState() {
    super.initState();
    _checkForDiseaseIngredient();
  }

  void _checkForDiseaseIngredient() async {
    final userDiseases = await _getUserDiseases();
    final recipeMaterials = await _getRecipeMaterials();
    if (userDiseases.isNotEmpty && recipeMaterials!.isNotEmpty) {
      final matchFound = userDiseases.any((disease) =>
          recipeMaterials.any((material) => material.contains(disease)));
      if (matchFound) {
        setState(() {
          widget.containsDiseaseIngredient = true;
        });
      }
    }
  }

  Future<List<String>> _getUserDiseases() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      String diseasesRaw = userDoc.data()?['disease'] ?? '';
      List<String> diseases =
          diseasesRaw.split(',').map((disease) => disease.trim()).toList();
      return diseases;
    }
    return [];
  }

  Future<List<String>?> _getRecipeMaterials() async {
    final recipeDoc =
        await _firestore.collection('recipes').doc(widget.recipeID).get();
    final materialsString = recipeDoc.data()?['materials'] as String?;
    final materialsList = materialsString?.split(',') ?? [];
    return materialsList;
  }

  void _toggleFavorite() async {
    if (widget.isFavorite != null) {
      setState(() {
        widget.isFavorite = !widget.isFavorite!;
      });

      DocumentReference userFavoritesRef = _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('favorites')
          .doc(widget.recipeID);

      if (widget.isFavorite!) {
        await userFavoritesRef.set({
          'recipeID': widget.recipeID,
        });
      } else {
        await userFavoritesRef.delete();
      }
    }
  }

  void _incrementViewCount() async {
    clickCount++; // Increment the counter on each click

    DocumentReference userClickCountsRef = _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('clickCounts')
        .doc(widget.recipeID);

    await userClickCountsRef.set({
      'recipeID': widget.recipeID,
      'clickCount': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      width: size.width * 0.7,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(0.0, 10.0),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.35),
            BlendMode.multiply,
          ),
          fit: BoxFit.cover,
          image: NetworkImage(widget.thumbnailUrl),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                widget.title,
                style: const TextStyle(fontSize: 19, color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              icon: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.isFavorite ? Colors.red : Colors.white,
              ),
              onPressed: _toggleFavorite,
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 18),
                SizedBox(width: 7),
                Text(widget.rating, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Row(
              children: [
                Icon(Icons.schedule, color: Colors.yellow, size: 18),
                SizedBox(width: 7),
                Text(widget.cookTime, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          if (widget.containsDiseaseIngredient)
            Positioned(
              right: 0,
              top: 0,
              child: Icon(Icons.close, size: 48, color: Colors.red),
            ),
        ],
      ),
    );
  }
}
