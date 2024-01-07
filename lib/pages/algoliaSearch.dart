import 'package:bitirme0/pages/recipeDetailsPage.dart';
import 'package:bitirme0/pages/recipe_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';

final Algolia algolia = Algolia.init(
  applicationId: 'V34BNVX4EG',
  apiKey: '5d4afae0fc4c38386e5364ab0149a84f',
);

class AlgoliaSearchPage extends StatefulWidget {
  @override
  _AlgoliaSearchPageState createState() => _AlgoliaSearchPageState();
}

class _AlgoliaSearchPageState extends State<AlgoliaSearchPage> {
  List<AlgoliaObjectSnapshot> _searchResults = [];
  bool _searching = false;
  TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _searchController
        .addListener(_onSearchChanged); // Arama metni değişikliğini dinler
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged); // Dinleyiciyi kaldırır
    _searchController.dispose(); // Denetleyiciyi temizler
    super.dispose();
  }

  // Arama değiştiğinde çağrılan fonksiyon
  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    } else {
      setState(() {
        _searchResults = [];
        _searching = false;
      });
    }
  }

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

  // Algolia üzerinde arama yapılmasını sağlayan fonksiyon
  void _performSearch(String searchText) async {
    setState(() {
      _searching = true;
    });

    String userDisease = '';
    if (FirebaseAuth.instance.currentUser != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      userDisease = userDoc.data()?['disease'] ?? '';
    }

    AlgoliaQuery query =
        algolia.instance.index('recipes_index').search(searchText);
    if (userDisease.isNotEmpty) {
      query = query.setFilters('NOT ingredients:${userDisease}');
    }

    try {
      AlgoliaQuerySnapshot querySnapshot = await query.getObjects();
      setState(() {
        _searchResults = querySnapshot.hits;
        _searching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _searching = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Recipes'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search for recipes...',
            ),
          ),
          // Arama sonuçlarını listelediğimiz bölüm
          Expanded(
            child: _searching
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final data = _searchResults[index].data;
                      return InkWell(
                        onTap: () {
                          _incrementViewCount(data['recipeID']);
                          // RecipeDetailsPage sayfasına yönlendirme
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RecipeDetailsPage(
                              title: data['name'] ?? 'Unnamed Recipe',
                              cookTime: data['duration'] ?? 'Unknown',
                              thumbnailUrl:
                                  data['url'] ?? 'assets/images/pizza.png',
                              description: data['description'] ??
                                  'No description provided.',
                              difficulty: data['difficulty'] ?? 'Unknown',
                              creator: data['addedBy'] ?? 'Unknown',
                              creatorID: data['creatorID'] ?? 'Unknown',
                              materials: data['materials'] ?? 'Unknown',
                              recipeID: data['recipeID'] ??
                                  'No description provided.',
                              category: data['category'] ?? 'Unknown',
                              calories: data['calories'] ?? 'Unknown',
                              isFavorite: data['isFavorite'] ?? false,
                            ),
                          ));
                        },
                        // RecipeCard widgetını kullanarak tarif kartlarını gösterme
                        child: RecipeCard(
                          title: data['name'] ?? 'Unnamed Recipe',
                          rating: data['rateAverage']?.toString() ?? 'N/A',
                          cookTime: data['duration'] ?? 'Unknown',
                          thumbnailUrl:
                              data['url'] ?? 'assets/default_recipe_image.png',
                          recipeID: _searchResults[index].objectID,
                          isFavorite: data['isFavorite'] ?? false,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
