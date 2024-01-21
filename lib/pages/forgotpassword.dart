import 'package:bitirme0/pages/login.dart';
import 'package:bitirme0/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../css.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late String email;
  final TextEditingController mail_controller = TextEditingController();
  final formkey = GlobalKey<FormState>();
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: kWhite,
              ),
            ),
            title: const Text(
              'Forgot Password',
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
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Center(
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
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: kBlue,
                    ),
                    child: SendMailButton(context),
                  ),
                ),
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

  TextButton SendMailButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          formkey.currentState!.save();
          String? result = await Auth().forgotPassword(email);
          if (result == "Mail sent to reset your password") {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Message"),
                  content: Text(result!),
                );
              },
            ).then((_) {
              Navigator.pushNamed(context, "/loginPage");
            });
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Warning"),
                    content: Text(result!),
                  );
                });
          }
        }
      },
      child: Text(
        'Send Email',
        style: kBodyText.copyWith(fontWeight: FontWeight.bold),
      ),
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
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.done,
    );
  }
}
