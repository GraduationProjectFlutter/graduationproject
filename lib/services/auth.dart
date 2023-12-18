import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<String?> loginController(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Login Successful";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          return "Invalid Email";
        case "user-disable":
          return "User has been disabled";
        case "user-not-found":
          return "User not found";
        case "wrong-password":
          return "Wrong password";
        default:
          return "Cannot Login";
      }
    }
  }

  Future<String?> register(String email, String username, String password,
      String confirmpassword) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore.collection("users").add({
        "email": email,
        "username": username,
        "userID": credential.user!.uid
      });
      return "Registration Successful";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          return "Email is already in use";
        case "invalid-email":
          return "Invalid Email";
        case "operation-not-allowed":
          return "Something went wrong";
        case "weak-password":
          return "Weak Password";
        default:
          return "Registration Failed";
      }
    }
  }

  Future<String?> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Mail sent to reset your password";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return "User not found";
        case "invalid-email":
          return "Invalid Email";
        case "operation-not-allowed":
          return "Something went wrong";
        case "user-disable":
          return "User has been disabled";
        default:
          return "Password reset failed";
      }
    }
  }

  Future<String?> getUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs[0].get('username') as String?;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Kullanıcı adını çekerken hata oluştu: $e");
      return null;
    }
  }

  Future<String> createRecipe(
      String? addedBy,
      String creatorID,
      String category,
      String description,
      String difficulty,
      String duration,
      String materials,
      String name,
      String cal,
      String url) async {
    try {
      var docid = _firestore.collection("recipes").doc().id;
      await _firestore.collection("recipes").doc(docid).set({
        "recipeID": docid,
        "addedBy": addedBy,
        "creatorID": creatorID,
        "category": category,
        "description": description,
        "difficulty": difficulty,
        "duration": duration,
        "materials": materials,
        "name": name,
        "calories": cal,
      });
      return docid;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  Future<List<Map<String, dynamic>>> getRecipes() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection("recipes").get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
