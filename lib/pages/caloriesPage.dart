import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:bitirme0/pages/recipeDetailsPage.dart';
import 'package:bitirme0/pages/recipe_card.dart';

final Algolia algolia = Algolia.init(
  applicationId: 'V34BNVX4EG',
  apiKey: '5d4afae0fc4c38386e5364ab0149a84f',
);

class CaloriesPage extends StatefulWidget {
  @override
  _CaloriesPageState createState() => _CaloriesPageState();
}

class _CaloriesPageState extends State<CaloriesPage> {
  List<AlgoliaObjectSnapshot> _searchResults = [];
  bool _searching = false;
  TextEditingController _searchController = TextEditingController();
  double _totalCalories = 0;

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
      print(e);
    }
  }

  void _addToTotalCalories(double calories) {
    setState(() {
      _totalCalories += calories;
    });
  }

  void _onCardTap(AlgoliaObjectSnapshot hit) {
    final data = hit.data;
    double calories = double.tryParse(data['calories']?.toString() ?? '0') ?? 0;
    _addToTotalCalories(calories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_fire_department, color: Colors.white),
            SizedBox(width: 10),
            Text('Kalori Arama', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 211, 101, 10),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.blueGrey),
                hintText: 'Search for calories in recipes...',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: _searching
                ? Center(child: CircularProgressIndicator())
                : _buildSearchResults(),
          ),
          _buildTotalCaloriesDisplay(),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final data = _searchResults[index].data;
        return GestureDetector(
          onTap: () => _onCardTap(_searchResults[index]),
          child: RecipeCard(
            title: data['name'] ?? 'Unnamed Recipe',
            rating: data['rateAverage']?.toString() ?? 'N/A',
            cookTime: data['duration'] ?? 'Unknown',
            thumbnailUrl: data['url'] ?? 'assets/default_recipe_image.png',
            recipeID: _searchResults[index].objectID,
            isFavorite: data['isFavorite'] ?? false,
          ),
        );
      },
    );
  }

  Widget _buildTotalCaloriesDisplay() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Color.fromARGB(255, 202, 127, 77),
      child: Text(
        'Total Calories: ${_totalCalories.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
