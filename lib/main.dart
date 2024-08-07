import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pblfinal/loginPage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyB9OJ6aQo3LNtj7LTenoU7HZKXVYAYf5SQ",
            authDomain: "pbl2-2aedd.firebaseapp.com",
            appId: "1:697548720487:web:2a571cdf1334ab3aeac7c2",
            messagingSenderId: "697548720487",
            storageBucket: "pbl2-2aedd.appspot.com",
            projectId: "pbl2-2aedd",));
            
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "QuickByte",
      home: LoginPage()
    );
  }
}
