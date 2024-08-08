import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pblfinal/uiHelper.dart';
import 'package:pblfinal/signupPage.dart';
import 'package:pblfinal/homePage.dart';
mixin nameConnection{
  static String userName='';
}

class LoginPage extends StatefulWidget with nameConnection{
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  logIn(String email, String password) async {
    if (email.length > 30) {
      FirebaseAuth.instance
          .setSettings(appVerificationDisabledForTesting: true);
      int domainIndex = email.indexOf('@');
      int nameIndex= email.indexOf('_');
      nameConnection.userName= email.substring(0,domainIndex);
      String sliced = email.substring(domainIndex + 1);
      if (sliced == 'students.isquareit.edu.in') {
        UserCredential? userCredential;
        try {
          userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password)
              .then((value) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          });
        } on FirebaseAuthException catch (e) {
          //???
          // ignore: use_build_context_synchronously
          if(e.code=="too-many-requests"){
            return UiHelper.CustomAlertBox(context, "Too many login attempts in a short period of time. Please try again a few minutes later!");
          }
          else if(e.code=="invalid-credential"){
            return UiHelper.CustomAlertBox(context, "Incorrect email-password combination. Please try again.");
          }
          else{
            return UiHelper.CustomAlertBox(context, e.code.toString());
          }
          
        }
      } else {
        UiHelper.CustomAlertBox(
            context, "Login only permitted with college mail id!");
      }
    } else {
      UiHelper.CustomAlertBox(
          context, "Login only permitted with college mail id!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        centerTitle: true,
      ),
       body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        UiHelper.CustomTextField(emailController, "Email", Icons.mail, false),
        UiHelper.CustomTextField(
            passwordController, "Password", Icons.password, true),
        SizedBox(height: 30),
        UiHelper.CustomButton(() {
          logIn(emailController.text.toString().trim(),
              passwordController.text.toString().trim());
        }, "Login"),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Do not have an account?",
              style: TextStyle(fontSize: 16),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ))
          ],
        )
      ]),
    );
  }
}
