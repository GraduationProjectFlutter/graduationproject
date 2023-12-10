import 'package:flutter/material.dart';
import 'package:bitirme0/pages/recipe_card.dart';

class MyRecipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String title = "Örnek Tarif";
    final String rating = "4.5";
    final String cookTime = "30 min";
    final String thumbnailAsset = "aassets/image/pizza.png";

    return Scaffold(
      appBar: AppBar(
        title: Text('My Recipe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RecipeCard(
              title: title,
              rating: rating,
              cookTime: cookTime,
              thumbnailUrl: thumbnailAsset,
            ),
            SizedBox(height: 20),
            Text(
              "Tarif Detayları Burada Görüntülenecek",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
