import 'package:algolia/algolia.dart';

class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: 'V34BNVX4EG', // Firestore'dan alınan Algolia Application ID
    apiKey:
        '5d4afae0fc4c38386e5364ab0149a84f', // Firestore'dan alınan Algolia API Key
  );
}

class AlgoliaService {
  final Algolia _algoliaApp = Application.algolia;

  AlgoliaService();

  Future<List<AlgoliaObjectSnapshot>> searchRecipes(String queryText) async {
    AlgoliaQuery query =
        _algoliaApp.instance.index('recipes_index').search(queryText);
    AlgoliaQuerySnapshot querySnapshot = await query.getObjects();
    return querySnapshot.hits;
  }
}
