import 'package:bitirme0/pages/recipeDetailsPage.dart';
import 'package:bitirme0/pages/recipe_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class seeAll extends StatefulWidget {
  @override
  _SeeAllState createState() => _SeeAllState();
}

class _SeeAllState extends State<seeAll> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late List<Map<String, dynamic>> _recipes; // Tariflerin saklandığı liste.

  @override
  void initState() {
    super.initState();
    _recipes = [];
    _loadMostClickedRecipes(); // En çok tıklanan tarifleri yükler.
  }

  // Kullanıcının en çok tıkladığı tarifleri Firestore'dan çeker.
  Future<void> _loadMostClickedRecipes() async {
    try {
      User? user = _auth.currentUser;

      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('clickCounts')
          .orderBy('clickCount', descending: true)
          .get();

      List<String> recipeIDs = querySnapshot.docs
          .map((DocumentSnapshot document) => document['recipeID'] as String)
          .toList();

      if (recipeIDs.length < 3) {
        try {
          QuerySnapshot additionalRecipesSnapshot = await _firestore
              .collection('recipes')
              .limit(3 - recipeIDs.length)
              .get();

          if (additionalRecipesSnapshot.docs.isNotEmpty) {
            setState(() {
              _recipes.addAll(additionalRecipesSnapshot.docs
                  .map((DocumentSnapshot document) =>
                      document.data() as Map<String, dynamic>)
                  .toList());
            });
          }
        } catch (e) {
          print('Error loading additional recipes: $e');
        }
      }

      QuerySnapshot recipeDetailsSnapshot = await _firestore
          .collection('recipes')
          .where(FieldPath.documentId, whereIn: recipeIDs)
          .limit(3)
          .get();

      setState(() {
        _recipes.addAll(recipeDetailsSnapshot.docs
            .map((DocumentSnapshot document) =>
                document.data() as Map<String, dynamic>)
            .toList());
      });
      _recipes.shuffle();
      _recipes = _recipes.take(3).toList();
    } catch (e) {
      print('Error loading most clicked recipes: $e');
    }
  }

  // Tüm tarifleri Firestore'dan çeker.
  Future<void> _loadRecipes() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('recipes').get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _recipes = querySnapshot.docs
              .map((DocumentSnapshot document) =>
                  document.data() as Map<String, dynamic>)
              .toList();
          _recipes.shuffle(); // Tarifleri karıştırır.
          _recipes = _recipes.take(3).toList(); // İlk 3 tarifi alır.
        });
      }
    } catch (e) {
      print('Error loading recipes: $e');
    }
  }

  // Tıklama sayısını artıran fonksiyon.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Recommended Recipes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false), // Geri butonunu gizler.
      body: ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> recipeData = _recipes[index];

          // Tarif kartına tıklandığında detay sayfasına yönlendirir
          return InkWell(
            onTap: () {
              _incrementViewCount(recipeData['recipeID']);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RecipeDetailsPage(
                  // Tarif detayları.
                  // Tarif verilerini alır, yoksa varsayılan değerleri kullanır.
                  title: recipeData['name'] ?? 'Unnamed Recipe',
                  cookTime: recipeData['duration'] ?? 'Unknown',
                  thumbnailUrl: recipeData['url'] ?? 'assets/images/pizza.png',
                  description:
                      recipeData['description'] ?? 'No description provided.',
                  difficulty:
                      recipeData['difficulty'] ?? 'No description provided.',
                  creator: recipeData['addedBy'] ?? 'No description provided.',
                  creatorID:
                      recipeData['creatorID'] ?? 'No description provided.',
                  materials:
                      recipeData['materials'] ?? 'No description provided.',
                  recipeID:
                      recipeData['recipeID'] ?? 'No description provided.',
                  category:
                      recipeData['category'] ?? 'No description provided.',
                  calories:
                      recipeData['calories'] ?? 'No description provided.',
                  isFavorite: recipeData['isFavorite'] ?? false,
                ),
              ));
            },
            // Tarif kartı widget'ını oluşturur.
            child: RecipeCard(
              title: recipeData['name'] ?? 'Unnamed Recipe',
              rating: recipeData['rateAverage']?.toString() ?? 'N/A',
              cookTime: recipeData['duration'] ?? 'Unknown',
              thumbnailUrl:
                  recipeData['url'] ?? 'assets/default_recipe_image.png',
              recipeID: recipeData['recipeID'],
              isFavorite: recipeData['isFavorite'] ?? false,
            ),
          );
        },
      ),
    );
  }
}




/* FİLTRELEME İÇİN DROPDOWN MENÜMÜZ
String _selectedDifficulty = 'All';
List<String> _difficulties = ['All', 'Easy', 'Medium', 'Hard'];

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Recommended Recipes'),
      actions: [
        DropdownButton(
          value: _selectedDifficulty,
          items: _difficulties.map((String difficulty) {
            return DropdownMenuItem(
              value: difficulty,
              child: Text(difficulty),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedDifficulty = newValue!;
              _loadRecipes(); // Tarifleri yeniden yükler
            });
          },
        ),
      ],
    ),
    // ... (diğer kodlarımız)
  );
}

// Tarifler yüklenirken uyguladığımız filtreleme
Future<void> _loadRecipes() async {
  try {
    Query query = _firestore.collection('recipes');
    if (_selectedDifficulty != 'All') {
      query = query.where('difficulty', isEqualTo: _selectedDifficulty);
    }
    QuerySnapshot querySnapshot = await query.get();

    // ... (Diğer kodlarımız)
  }
}   */


/* SIRALAM İÇİN DROPDOWN MENÜMÜZ
String _selectedSorting = 'Popularity';
List<String> _sortingOptions = ['Popularity', 'Newest', 'Lowest Calories'];

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Recommended Recipes'),
      actions: [
        DropdownButton(
          value: _selectedSorting,
          items: _sortingOptions.map((String option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedSorting = newValue!;
              _loadRecipes(); // Tarifleri yeniden yükler
            });
          },
        ),
      ],
    ),
    // ... (Diğer kodlar)
  );
}

// Tarifleri yüklerken sıralama uygular
Future<void> _loadRecipes() async {
  try {
    Query query = _firestore.collection('recipes');
    switch (_selectedSorting) {
      case 'Newest':
        query = query.orderBy('createdDate', descending: true);
        break;
      case 'Lowest Calories':
        query = query.orderBy('calories', descending: false);
        break;
      // Varsayılan olarak popülerliğe göre sırala
      default:
        query = query.orderBy('clickCount', descending: true);
        break;
    }
    QuerySnapshot querySnapshot = await query.get();

    // ... (Diğer kodlar)
  }
}    */


/*  TARİFLERİN GÖRSELİNİ DAHA FAZLA ZENGİNLEŞTİRMEK İÇİN

// RecipeCard widget'ını güncelleme
class RecipeCard extends StatelessWidget {
  final int cookTime;
  final double rating;

  //Constuctor ve diğer metodlarımız.

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('$cookTime min | Rating: $rating'),
        leading: Image.network(thumbnailUrl, fit: BoxFit.cover),
        // ... (Diğer özelliklerimiz)
      ),
    );
  }
}  */

