import 'package:bitirme0/pages/addRecipe.dart';
import 'package:bitirme0/pages/algoliaSearch.dart';
import 'package:bitirme0/pages/caloriesPage.dart';
import 'package:bitirme0/pages/home.dart';
import 'package:bitirme0/pages/profilPage.dart';
import 'package:bitirme0/pages/favoritesPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitirme0/pages/allRecipes.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorites'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.computer),
            title: Text('CookifyAl'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlgoliaSearchPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Recipe'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRecipe()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calculate),
            title: Text('Calorie Calculation'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CaloriesPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.view_list),
            title: Text('See All'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => allRecipes()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out of Account'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/loginPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out '),
            onTap: () {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
          ),
        ],
      ),
    );
  }
}


/* KULLANICI PROFİL FOTOSU VE BİLGİLERİNİ GÖRÜNTÜLEMEK 

User? currentUser = FirebaseAuth.instance.currentUser;

@override
Widget build(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(currentUser?.displayName ?? 'User Name'),
          accountEmail: Text(currentUser?.email ?? 'email@example.com'),
          currentAccountPicture: CircleAvatar(
            backgroundImage: currentUser?.photoURL != null
                ? NetworkImage(currentUser!.photoURL!)
                : AssetImage('assets/default_user.png') as ImageProvider,
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        // Diğer ListTile widget'ları...
      ],
    ),
  );
}
*/


/* BAZI TEMA DEĞİŞTİRMEK VEYA EKLEMEK

bool _darkTheme = false;

@override
Widget build(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        // DrawerHeader ve diğer ListTile'lar...

        SwitchListTile(
          title: Text('Dark Theme'),
          value: _darkTheme,
          onChanged: (bool value) {
            setState(() {
              _darkTheme = value;
              // Tema değiştirme kodunu burada ekleyin
            });
          },
          secondary: Icon(_darkTheme ? Icons.dark_mode : Icons.light_mode),
        ),
      ],
    ),
  );
}    */

