import 'dart:io';
import 'package:bitirme0/pages/allRecipes.dart';
import 'package:bitirme0/pages/addRecipe.dart';
import 'package:bitirme0/pages/favoritesPage.dart';
import 'package:bitirme0/pages/home.dart';
import 'package:bitirme0/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _diseaseController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final getuserName = Auth().getUserName();
  File? _imageFile;
  int selectedIndex = 3;
  String? username = null;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProfileImage();
  }

  void _loadUserData() {
    if (user != null) {
      _usernameController.text = user!.displayName ?? '';
      _emailController.text = user!.email ?? '';
      _firestore.collection('users').doc(user!.uid).get().then((document) {
        _diseaseController.text = document.data()?['disease'] ?? '';
      });
    }
  }

  void _changePassword() async {
    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    if (currentPassword.isNotEmpty && newPassword.isNotEmpty) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: currentPassword,
        );

        await user!.reauthenticateWithCredential(credential);
        await user!.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password updated successfully.')));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating password. ${e.message}')));
      }
    }
  }

  void _updateProfile() async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user found for update.')),
      );
      return;
    }
    String diseaseInfo = _diseaseController.text.trim();
    DocumentReference userDocRef =
        _firestore.collection('users').doc(user?.uid);

    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    if (!userDocSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User document does not exist.')),
      );
      return;
    }

    Map<String, dynamic> updateData = {};
    if (diseaseInfo.isNotEmpty) {
      updateData['disease'] = diseaseInfo;
    } else {
      updateData['disease'] = FieldValue.delete();
    }

    try {
      await userDocRef.update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully.')),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  void _loadProfileImage() {
    setState(() {
      _imageFile = Auth.profileImageFile;
    });
  }

  Future<void> _pickAndUpdateProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        String filePath = 'profile_images/${user!.uid}/${DateTime.now()}.png';
        UploadTask task =
            FirebaseStorage.instance.ref().child(filePath).putFile(imageFile);

        TaskSnapshot snapshot = await task;
        final url = await snapshot.ref.getDownloadURL();

        await user!.updatePhotoURL(url);
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile image updated successfully.')),
        );
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile image: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: ListView(
              children: [
                GestureDetector(
                  onTap: _pickAndUpdateProfileImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (user?.photoURL != null
                                ? NetworkImage(user!.photoURL!)
                                : AssetImage('assets/default_profile.png'))
                            as ImageProvider,
                    child: Align(
                      alignment: Alignment.bottomRight,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                namecall(),
                SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _showEditUsernameDialog,
                  icon: Icon(Icons.edit),
                  label: Text('Edit Username'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showChangePasswordDialog(),
                  icon: Icon(Icons.lock),
                  label: Text('Change Password'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                ),
                SizedBox(height: 50),
                TextField(
                  controller: _diseaseController,
                  decoration: InputDecoration(
                    labelText: 'Disease (if any)',
                    prefixIcon: Icon(Icons.sick),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Update Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<String?> namecall() {
    return FutureBuilder(
        future: getuserName,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Hata: ${snapshot.error}");
          } else {
            username = snapshot.data as String?;
            return Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: username,
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            );
          }
        });
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
              ),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
              ),
              TextField(
                controller: _diseaseController,
                decoration: InputDecoration(
                  labelText: 'Disease (if any)',
                  prefixIcon: Icon(Icons.sick),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _changePassword();
                Navigator.of(context).pop();
              },
              child: Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _showEditUsernameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Username'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              namecall(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateUsername();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateUsername() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: _emailController.text)
        .limit(1)
        .get();
    var docID = querySnapshot.docs.first.id;

    String newDisplayName = _usernameController.text.trim();
    setState(() {
      user!.updateDisplayName(newDisplayName);
    });

    if (newDisplayName.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(docID)
            .update({'username': newDisplayName});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Display name updated successfully.')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating display name. ${e.message}')),
        );
      }
    }
  }
}
