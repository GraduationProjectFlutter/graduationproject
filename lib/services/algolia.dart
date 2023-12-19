import 'package:algolia/algolia.dart';

class AlgoliaService {
  static const String _applicationId = 'YourActualAlgoliaApplicationId';
  static const String _apiKey = 'YourActualAlgoliaApiKey';
  static const String _indexName = 'YourIndexName';

  late final Algolia _algolia;
  late final AlgoliaIndexReference _index;

  AlgoliaService() {
    _algolia = Algolia.init(applicationId: _applicationId, apiKey: _apiKey);
    _index = _algolia.index(_indexName);
  }

  Future<List<AlgoliaObjectSnapshot>> search(String searchText) async {
    AlgoliaQuery query = _index.search(searchText);
    AlgoliaQuerySnapshot querySnapshot = await query.getObjects();
    return querySnapshot.hits;
  }
}
