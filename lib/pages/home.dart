import 'package:bitirme0/pages/NawBar.dart';
import 'package:bitirme0/pages/addRecipe.dart';
import 'package:bitirme0/pages/favoritesPage.dart';
import 'package:bitirme0/pages/popularRecipes.dart';
import 'package:bitirme0/pages/profilPage.dart';
import 'package:bitirme0/pages/seeAll.dart';
import 'package:bitirme0/services/auth.dart';
import 'package:bitirme0/pages/algoliaSearch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Container> cards = [];
  final getuserName = Auth().getUserName(); // Kullanıcı adını geitren servis

  final db = FirebaseFirestore.instance;
  int selectedIndex = 0; // Alt navigasyon için seçili index
  TextEditingController n1 = TextEditingController();
  var name = "";
  GlobalKey<RefreshIndicatorState> _refreshKeySeeAll =
      GlobalKey<RefreshIndicatorState>();
  GlobalKey<RefreshIndicatorState> _refreshKeyPopularRecipes =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  // Alt navigasyon elemanına tıklandığında çalışacak fonksiyon
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
          MaterialPageRoute(builder: (context) => AlgoliaSearchPage()),
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: const Drawer(
        shadowColor: Colors.black,
        backgroundColor: Colors.black,
        child: NavBar(),
      ),
      appBar: AppBar(),
      // Alt navigasyon çubuğu
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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Hata: ${snapshot.error}");
          } else {
            String? username = snapshot.data as String?;
            return Column(
              children: [
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: screenWidth * 0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Hey $username",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Icon(Icons.waving_hand_outlined, size: 30),
                            ],
                          ),
                        ),
                        SizedBox(height: 3),
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.05),
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
                        SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
                _buildRecipeCard2(),
                Expanded(
                  child: RefreshIndicator(
                    key: _refreshKeySeeAll,
                    onRefresh: () async {
                      // Implement the logic to refresh the seeAll section
                      // For example, you can call a function to reload the data
                      setState(() {
                        // Your refresh logic here
                        seeAll();

                        // Pop the current page
                        Navigator.pop(context);

                        // Push the same page again
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      });
                    },
                    child: seeAll(),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    key: _refreshKeyPopularRecipes,
                    onRefresh: () async {
                      // Implement the logic to refresh the seeAll section
                      // For example, you can call a function to reload the data
                      setState(() {
                        // Your refresh logic here
                        popularRecipes();

                        // Pop the current page
                        Navigator.pop(context);

                        // Push the same page again
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      });
                    },
                    child: popularRecipes(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildRecipeCard2() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AlgoliaSearchPage(),
        ));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 70),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/robot.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 15,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Search for recipes',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
