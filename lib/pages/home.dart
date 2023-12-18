import 'package:bitirme0/pages/CookifyAI.dart';
import 'package:bitirme0/pages/NawBar.dart';
import 'package:bitirme0/pages/addRecipe.dart';
import 'package:bitirme0/pages/favoritesPage.dart';
import 'package:bitirme0/pages/popularRecipes.dart';
import 'package:bitirme0/pages/profilPage.dart';
import 'package:bitirme0/pages/recipe_card.dart';
import 'package:bitirme0/pages/seeAll.dart';
import 'package:bitirme0/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Container> cards = [];
  final getuserName = Auth().getUserName();

  final db = FirebaseFirestore.instance;
  late TabController _tabController;
  int selectedIndex = 0;
  TextEditingController n1 = TextEditingController();
  int _selectedIndex = 0;
  var name = "";

  @override
  void initState() {
    super.initState();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritesPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CookifyAI()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddRecipe()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const Drawer(
        shadowColor: Colors.black,
        backgroundColor: Colors.black,
        child: NavBar(),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.computer), label: 'CookifyAI'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Recipe'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: FutureBuilder(
        future: getuserName,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Hata: ${snapshot.error}");
          } else {
            String? username = snapshot.data as String?;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Hey $username",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.waving_hand_outlined, size: 30),
                            ],
                          ),
                        ),
                        SizedBox(height: 3),
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "What are you cooking today ?",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
                SearchBar(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  leading: const Icon(Icons.search),
                  // other arguments
                ),
                Expanded(
                  child: seeAll(),
                ),
                Expanded(
                  child: popularRecipes(),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
