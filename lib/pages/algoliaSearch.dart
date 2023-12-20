import 'package:bitirme0/pages/recipeDetailsPage.dart';
import 'package:bitirme0/pages/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';

// Algolia ayarlarınız
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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

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

  void _performSearch(String searchText) async {
    setState(() {
      _searching = true;
    });

    AlgoliaQuery query =
        algolia.instance.index('recipes_index').search(searchText);

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
      print(e); // Hata yönetimi için uygun bir çözüm bulunmalıdır.
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
          Expanded(
            child: _searching
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final data = _searchResults[index].data;
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RecipeDetailsPage(
                              title: data['name'] ?? 'Unnamed Recipe',
                              cookTime: data['duration'] ?? 'Unknown',
                              thumbnailUrl:
                                  data['imageUrl'] ?? 'assets/images/pizza.png',
                              description: data['description'] ??
                                  'No description provided.',
                              difficulty: data['difficulty'] ?? 'Unknown',
                              creator: data['addedBy'] ?? 'Unknown',
                              creatorID: data['creatorID'] ?? 'Unknown',
                              materials: data['materials'] ?? 'Unknown',
                              recipeID: _searchResults[index].objectID,
                              category: data['category'] ?? 'Unknown',
                              calories: data['calories'] ?? 'Unknown',
                              isFavorite: data['isFavorite'] ?? false,
                            ),
                          ));
                        },
                        child: RecipeCard(
                          title: data['name'] ?? 'Unnamed Recipe',
                          rating: data['rateAverage']?.toString() ?? 'N/A',
                          cookTime: data['duration'] ?? 'Unknown',
                          thumbnailUrl: data['imageUrl'] ??
                              'assets/default_recipe_image.png',
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