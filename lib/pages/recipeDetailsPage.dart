import 'package:bitirme0/css.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RecipeDetailsPage extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: CustomScrollView(slivers: [
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
                  // Burada eklediğimiz SizedBox ile Row ve Text arasına bir boşluk ekledik.

                  Padding(
                    padding: const EdgeInsets.only(
                        right:
                            5.0), // İstenilen boşluk miktarını burada belirtin
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
                    padding: const EdgeInsets.only(
                        right:
                            5.0), // İstenilen boşluk miktarını burada belirtin
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
              SizedBox(width: 20.0),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ],
          ),
        )
      ])),
    );
  }
}
