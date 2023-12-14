import 'package:bitirme0/css.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeDetailsPage extends StatelessWidget {
  String rating = '0.0';
  final String title;
  final String difficulty;
  final String cookTime;
  final String thumbnailUrl;
  final String creator;
  final String creatorID;
  final String recipeID;
  final String description;
  final String category;
  final String materials;
  final String calories;
  final bool isFavorite;

  RecipeDetailsPage({
    required this.title,
    required this.cookTime,
    required this.difficulty,
    required this.thumbnailUrl,
    required this.creator,
    required this.creatorID,
    required this.recipeID,
    required this.description,
    required this.materials,
    required this.category,
    required this.calories,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white, // Geri dönme ikonunun rengi
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                expandedHeight: 350,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(10),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(70),
                        topRight: Radius.circular(70),
                      ),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          Container(
                            width: 80,
                            height: 4,
                            color: Color(0xfff3C444C),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                color: Color(0xFFFFD700),
                              ),
                              SizedBox(width: 10.0),
                              Text(cookTime, style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.whatshot,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10.0),
                              Text(calories, style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                              5.0), // İstenilen boşluk miktarını burada belirtin
                          child: Row(
                            children: [
                              Icon(
                                Icons.equalizer,
                                color: kBlue,
                                size: 30,
                              ),
                              SizedBox(width: 10.0),
                              Text(difficulty, style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Materials",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        List<String> materialList = materials.split(',');

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < materialList.length; i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${i + 1}.",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 10.0),
                                      Expanded(
                                        child: Text(
                                          materialList[i].trim(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        description,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) async {
                        var docRef =
                            firestore.collection("recipes").doc(recipeID);
                        var snapshot = await docRef.get();
                        var data = snapshot.data();

                        if (data != null) {
                          Map<String, dynamic> ratings = data['ratings'] ?? {};
                          ratings[auth.currentUser!.uid] = rating.toString();

                          double average = calculateAverageRating(ratings);

                          docRef.set({
                            "ratings": ratings,
                            "rateAverage": average.toStringAsFixed(2)
                          }, SetOptions(merge: true));
                        }
                      },
                    ),
                    SizedBox(height: 5.0),
                    FutureBuilder(
                        future: ratingValue(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            return Text(snapshot.data!);
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<String> ratingValue() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    var docRef = firestore.collection("recipes").doc(recipeID);
    var snapshot = await docRef.get();
    var data = snapshot.data();

    if (data != null && data.containsKey('ratings')) {
      Map<String, dynamic> ratings = data['ratings'];
      double averageRating = calculateAverageRating(ratings);
      return averageRating.toStringAsFixed(2);
    }

    return '-';
  }

  double calculateAverageRating(Map<String, dynamic> ratings) {
    double sum = 0;
    ratings.forEach((userId, rating) {
      sum += double.parse(rating);
    });
    return sum / ratings.length;
  }
}
