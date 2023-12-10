import 'dart:io';
import 'package:bitirme0/css.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitirme0/services/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipe();
}

class _AddRecipe extends State<AddRecipe> {
  final formkey = GlobalKey<FormState>();
  ImagePicker picker = ImagePicker();
  final db = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();
  final auth = FirebaseAuth.instance;
  File? imagePicked;
  int selectedIndex = 2;

  String description = "";
  String difficulty = "";
  String duration = "";
  String materials = "";
  String name = "";
  String cal = "";
  String url = "";
  String profession = 'Easy';
  String category = 'Breakfast';
  var items = [
    'Easy',
    'Medium',
    'Hard',
  ];
  var categoryItems = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Appetizer',
    'Salad',
    'Dessert',
    'Vegetarian'
  ];
  String email = "";
  @override
  void initState() {
    super.initState();
    whenStartPrefs();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Create Recipe'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          buildBottonNavigationBarItem(
              context, Icons.home, 'Home', '/homePage', 0),
          buildBottonNavigationBarItem(
              context, Icons.favorite, 'Favorites', '/favoritesPage', 1),
          buildBottonNavigationBarItem(
              context, Icons.add, 'Add Recipe', '/createrecipePage', 2),
          buildBottonNavigationBarItem(
              context, Icons.person, 'Profile', '/profilePage', 3),
          logoutItem(context, Icons.logout, 'Logout', '/loginPage', 4),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: Form(
          key: formkey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: size.width * 0.14,
                      backgroundColor: Colors.grey[400]?.withOpacity(0.5),
                      child: imagePicked != null
                          ? ClipOval(
                              child: Image.file(
                                imagePicked!,
                                width: size.width * 0.28,
                                height: size.width * 0.28,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              FontAwesomeIcons.camera,
                              color: kWhite,
                              size: size.width * 0.1,
                            ),
                    ),
                  ),
                  Positioned(
                    top: size.width * 0.15,
                    left: size.width * 0.56,
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          var result = await picker.pickImage(
                            source: ImageSource.gallery,
                            maxHeight: 150,
                            maxWidth: 350,
                            imageQuality: 100,
                          );
                          if (result == null) {
                            return;
                          }
                          final temp = File(result.path);
                          setState(() {
                            imagePicked = temp;
                          });
                        } on PlatformException catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Container(
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        decoration: BoxDecoration(
                          color: kBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: kWhite, width: 2),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.arrowUp,
                          color: kWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 30.0, right: 30.0, bottom: 10.0),
                child: Center(
                  child: TextFormField(
                    maxLength: 20,
                    onSaved: (newValue) {
                      name = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) return "Fill the blank";
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 50.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: kBlue),
                        borderRadius:
                            BorderRadius.circular(25.0), // Oval şekil için
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kBlue, width: 2),
                        borderRadius:
                            BorderRadius.circular(25.0), // Oval şekil için
                      ),
                      hintText: 'Enter your Recipe name',
                      labelText: 'Recipe Name',
                      prefixIcon: Icon(Icons.person, color: kBlue),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 25.0, right: 25.0, bottom: 10.0),
                child: Center(
                  child: TextFormField(
                    maxLength: 6,
                    onSaved: (newValue) {
                      duration = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) return "Fill the blank";
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 50.0),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: kBlue),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: kBlue, width: 2),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      hintText: 'Enter the minute',
                      labelText: 'Duration',
                      prefixIcon: const Icon(Icons.access_time, color: kBlue),
                    ),
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 25.0, right: 25.0, bottom: 10.0),
                  child: Center(
                      child: TextFormField(
                          maxLength: 200,
                          onSaved: (newValue) {
                            materials = newValue!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) return "Fill the blank";
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 50.0),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: kBlue),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: kBlue, width: 2),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            hintText: 'Enter the materials:item1,item2,item3..',
                            labelText: 'Materials',
                            prefixIcon:
                                const Icon(Icons.receipt_rounded, color: kBlue),
                          )))),
              Container(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 25.0, right: 25.0, bottom: 10.0),
                  child: TextFormField(
                      maxLength: 200,
                      onSaved: (newValue) {
                        description = newValue!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) return "Fill the blank";
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50.0),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: kBlue),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kBlue, width: 2),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: 'Enter the description',
                        labelText: 'Descriptionn',
                        prefixIcon: const Icon(Icons.book, color: kBlue),
                      ))),
              Container(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 30.0, right: 30.0, bottom: 10.0),
                child: Center(
                  child: TextFormField(
                    maxLength: 5,
                    onSaved: (newValue) {
                      cal = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) return "Fill the blank";
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 50.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: kBlue),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kBlue, width: 2),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      hintText: 'Enter your Calories',
                      labelText: 'Calories',
                      prefixIcon: Icon(Icons.whatshot, color: kBlue),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, top: 4, bottom: 10, right: 30),
                child: Row(
                  children: [
                    const Icon(Icons.equalizer, color: kBlue),
                    const SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: Text(
                        'Difficulty:',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 17),
                      ),
                    ),
                    Expanded(
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        value: profession,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: kBlue,
                        ),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Center(
                              child: Text(
                                items,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 17),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            profession = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, top: 4, bottom: 10, right: 30),
                child: Row(
                  children: [
                    const Icon(Icons.equalizer, color: kBlue),
                    const SizedBox(
                      width: 14,
                    ),
                    Expanded(
                      child: Text(
                        'Category:',
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 17),
                      ),
                    ),
                    Expanded(
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        value: category,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: kBlue,
                        ),
                        items: categoryItems.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Center(
                              child: Text(
                                items,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 17),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            category = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  if (imagePicked != null) {
                    if (formkey.currentState!.validate()) {
                      formkey.currentState!.save();
                      var docid = "";
                      await Auth()
                          .createRecipe(
                              auth.currentUser!.email,
                              auth.currentUser!.uid,
                              category,
                              description,
                              profession,
                              duration,
                              materials,
                              name,
                              cal,
                              url)
                          .then((value) => docid = value);

                      var imageRef = storageRef.child("recipeImage/$docid");
                      try {
                        await imageRef.putFile(imagePicked!);
                      } on FirebaseException catch (e) {
                        print(e.toString());
                      }
                      url = await imageRef.getDownloadURL();
                      db.collection("recipes").doc(docid).update({'url': url});
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Created')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please select an image')));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: kBlue,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                  child: const Center(
                      child: Text(
                    "Create",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem buildBottonNavigationBarItem(BuildContext context,
      IconData icon, String label, String direction, int index) {
    return BottomNavigationBarItem(
      icon: SizedBox(
        height: 42,
        width: 24,
        child: InkWell(
          onTap: () {
            if (selectedIndex != index) {
              setState(() {
                selectedIndex = index;
              });
              Navigator.pushReplacementNamed(context, direction);
            }
          },
          child: Icon(
            icon,
            color: selectedIndex == index ? Colors.green : Colors.grey,
          ),
        ),
      ),
      label: label,
    );
  }

  Padding appLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: 350,
        height: 200,
        child: Center(
            child: Image.asset(
          'assets/image/login.png',
        )),
      ),
    );
  }

  Future<void> whenStartPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email")!;
    setState(() {});
  }

  BottomNavigationBarItem logoutItem(BuildContext context, IconData icon,
      String label, String direction, int index) {
    return BottomNavigationBarItem(
      icon: SizedBox(
        height: 42,
        width: 24,
        child: InkWell(
          onTap: () async {
            if (selectedIndex != index) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();

              setState(() {
                selectedIndex = index;
              });
              Navigator.pushReplacementNamed(context, direction);
            }
          },
          child: Icon(
            icon,
            color: selectedIndex == index ? Colors.green : Colors.grey,
          ),
        ),
      ),
      label: label,
    );
  }
}
