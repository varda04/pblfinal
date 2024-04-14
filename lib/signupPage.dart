import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pblfinal/loginPage.dart';
import 'package:pblfinal/homePage.dart';
import 'package:pblfinal/uiHelper.dart';
import 'package:firebase_core/firebase_core.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signUp(String email, String password) async{
    if(email=="" && password==""){
      UiHelper.CustomAlertBox(context, "Enter required fields");
    }
    if (email.length > 30) {
      FirebaseAuth.instance
          .setSettings(appVerificationDisabledForTesting: true);
      int domainIndex = email.indexOf('@');
      String sliced = email.substring(domainIndex + 1);
    if(sliced=="students.isquareit.edu.in"){
      UserCredential? userCredential;
      try{
        userCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
          // UiHelper.CustomAlertBox(context, "successful");
        }
        );
      }
      on FirebaseAuthException catch(ex){
        return UiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up Page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextField(emailController, "Email", Icons.email, false),
          UiHelper.CustomTextField(passwordController, "Password", Icons.password_sharp, true),
          SizedBox(height: 30),
          UiHelper.CustomButton((){
            signUp(emailController.text.toString(), passwordController.text.toString());
          }, "Sign up"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
              }, child: Text("Log In"))
            ],
          )
        ]),
    );
  }
}
