import 'package:bitirme0/css.dart';
import 'package:bitirme0/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController mail_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();
  bool _isChecked = false;
  final formkey = GlobalKey<FormState>();
  late String email;
  late String password;
  @override
  void initState() {
    super.initState();
    whenStartPrefs();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          backgroundColor: Colors.transparent,
          body: Form(
            key: formkey,
            child: Column(
              children: [
                const Flexible(
                  child: Center(
                    child: Text(
                      'Cookify',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                    ),
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
                    child: email_textfield(),
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
                    child: password_textfield(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, "/RegistrationPage"),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: kWhite,
                              ),
                            ),
                          ),
                          child: Text(
                            'Create New Account',
                            style: kBodyText.copyWith(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, "/ForgetPassword"),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: kWhite,
                              ),
                            ),
                          ),
                          child: Text(
                            'Forget Password',
                            style: kBodyText.copyWith(fontSize: 16.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                loginButton(size, context),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container loginButton(Size size, BuildContext context) {
    var staticPassword = '';
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.8,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(16), color: kBlue),
      child: TextButton(
        onPressed: () async {
          if (formkey.currentState!.validate()) {
            formkey.currentState!.save();

            var result = await Auth().loginController(email, password);
            if (result == "Login Successful") {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (_isChecked == true) {
                prefs.setString("password", password_controller.text);
              }
              prefs.setString("email", mail_controller.text);

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(result!)));
              Navigator.pushReplacementNamed(context, "/HomePage");
              staticPassword = password_controller.text;
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(result!)));
            }
            setState(() {});
          }
        },
        child: Text(
          'Login',
          style: kBodyText.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  TextFormField password_textfield() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Fill the blank";
        }
      },
      onSaved: (value) {
        password = value!;
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
        prefixText: ' ',
        hintStyle: kBodyText,
      ),
      obscureText: true,
      style: kBodyText,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.done,
    );
  }

  TextFormField email_textfield() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
      },
      onSaved: (value) {
        email = value!;
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
        prefixText: ' ',
        hintStyle: kBodyText,
      ),
      style: kBodyText,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  Future<void> whenStartPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("email") != null &&
        prefs.getBool("isLoggedIn") == true) {
      mail_controller.text = prefs.getString("email")!;
      password_controller.text = prefs.getString("password")!;
      _isChecked = prefs.getBool("isLoggedIn")!;
    } else {
      email = "";
      password = "";
    }
    setState(() {});
  }
}
