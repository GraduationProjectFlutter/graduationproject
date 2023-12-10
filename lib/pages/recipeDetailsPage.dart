import 'package:flutter/material.dart';

class RecipeDetailsPage extends StatelessWidget {
  final String title;
  final String rating;
  final String cookTime;
  final String thumbnailAsset;
  final String description;

  RecipeDetailsPage({
    required this.title,
    required this.rating,
    required this.cookTime,
    required this.thumbnailAsset,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(thumbnailAsset),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Text('Rating: $rating', style: TextStyle(fontSize: 18)),
            Text('Cook Time: $cookTime', style: TextStyle(fontSize: 18)),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
