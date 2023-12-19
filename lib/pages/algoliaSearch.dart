import 'package:bitirme0/services/algolia.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';

class AlgoliaSearchPage extends StatefulWidget {
  @override
  _AlgoliaSearchPageState createState() => _AlgoliaSearchPageState();
}

class _AlgoliaSearchPageState extends State<AlgoliaSearchPage> {
  final AlgoliaService _algoliaService = AlgoliaService();
  List<AlgoliaObjectSnapshot> _searchResults = [];
  bool _searching = false;

  void _onSearchChanged(String value) async {
    if (value.isNotEmpty) {
      setState(() => _searching = true);
      List<AlgoliaObjectSnapshot> results = await _algoliaService.search(value);
      setState(() {
        _searchResults = results;
        _searching = false;
      });
    } else {
      setState(() {
        _searchResults.clear();
        _searching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search for recipes...',
              ),
            ),
          ),
          Expanded(
            child: _searching
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      AlgoliaObjectSnapshot snap = _searchResults[index];
                      return ListTile(
                        title: Text(snap.data['name']),
                        subtitle: Text(snap.data['description']),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
