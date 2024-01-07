import 'dart:io';

import 'package:bitirme0/css.dart';
import 'package:bitirme0/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bitirme0/pages/login.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPage();
}

class _RegistrationPage extends State<RegistrationPage> {
  final TextEditingController mail_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();
  bool _isChecked = false;
  final formkey = GlobalKey<FormState>();
  late String email, password, confirmpassword, username;
  final TextEditingController name_controller = TextEditingController();
  final TextEditingController confirmpassword_controller =
      TextEditingController();
  final TextEditingController _diseaseController = TextEditingController();
  File? imagePicked;
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var collection = firestore.collection('users');
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [Colors.black, Colors.transparent],
          ).createShader(rect),
          blendMode: BlendMode.darken,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/login2.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              ),
            ),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: kWhite,
              ),
            ),
            title: Text(
              'Register',
              style: kBodyText,
            ),
            centerTitle: true,
          ),
          backgroundColor: Colors.transparent,
          body: Form(
            key: formkey,
            child: Column(
              children: [
                SizedBox(
                  height: size.width * 0.1,
                ),
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
                              Auth.profileImageFile = imagePicked;
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
                          child: Icon(
                            FontAwesomeIcons.arrowUp,
                            color: kWhite,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey[600]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: user(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey[600]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Email(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey[600]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Password(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey[600]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: confirmPassword(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey[600]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: DiseaseField(), // Hastalık alanını buraya ekleyin
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                registerButton(size, context),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  TextFormField Email() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Fill the blank";
        }
      },
      onSaved: (newValue) {
        email = newValue!;
      },
      controller: mail_controller,
      decoration: const InputDecoration(
        border: InputBorder.none,
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(
            FontAwesomeIcons.envelope,
            size: 26,
            color: kWhite,
          ),
        ),
        hintText: 'Email',
        hintStyle: kBodyText,
      ),
      style: kBodyText,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  TextFormField user() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Fill the blank";
        }
      },
      onSaved: (newValue) {
        username = newValue!;
      },
      controller: name_controller,
      decoration: const InputDecoration(
        border: InputBorder.none,
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(
            FontAwesomeIcons.user,
            size: 26,
            color: kWhite,
          ),
        ),
        hintText: 'User',
        hintStyle: kBodyText,
      ),
      style: kBodyText,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
    );
  }

  TextFormField Password() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Fill the blank";
        }
      },
      onSaved: (newValue) {
        password = newValue!;
      },
      controller: password_controller,
      decoration: const InputDecoration(
        border: InputBorder.none,
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(
            FontAwesomeIcons.lock,
            size: 26,
            color: kWhite,
          ),
        ),
        hintText: 'Password',
        hintStyle: kBodyText,
      ),
      obscureText: true,
      style: kBodyText,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
    );
  }

  TextFormField confirmPassword() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Fill the blank";
        }
      },
      onSaved: (newValue) {
        confirmpassword = newValue!;
      },
      controller: confirmpassword_controller,
      decoration: const InputDecoration(
        border: InputBorder.none,
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(
            FontAwesomeIcons.lock,
            size: 26,
            color: kWhite,
          ),
        ),
        hintText: 'Confirm Password',
        hintStyle: kBodyText,
      ),
      obscureText: true,
      style: kBodyText,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.done,
    );
  }

  TextFormField DiseaseField() {
    return TextFormField(
      controller: _diseaseController,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(
            FontAwesomeIcons.heartbeat,
            size: 26,
            color: kWhite,
          ),
        ),
        hintText: 'Disease (Optional)',
        hintStyle: kBodyText,
      ),
      style: kBodyText,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
    );
  }

  Container registerButton(Size size, BuildContext context) {
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.8,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(16), color: kBlue),
      child: TextButton(
        onPressed: () async {
          if (formkey.currentState!.validate()) {
            formkey.currentState!.save();
            if (password != confirmpassword) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Passwords does not match")));
            } else {
              // Auth servisinin register metodunu güncelleyerek disease bilgisini de parametre olarak geçirin
              var result = await Auth().register(
                  email,
                  username,
                  password,
                  confirmpassword,
                  _diseaseController
                      .text // hastalık bilgisi parametre olarak eklendi
                  );
              if (result == "Registration Successful") {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(result!)));
                Navigator.pushReplacementNamed(context, "/loginPage");
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(result!)));
              }
            }
          }
        },
        child: Text(
          'Register',
          style: kBodyText.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
