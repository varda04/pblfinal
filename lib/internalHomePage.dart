import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InternalHomePage extends StatefulWidget {
  const InternalHomePage({super.key});

  @override
  State<InternalHomePage> createState() => _InternalHomePageState();
}

class _InternalHomePageState extends State<InternalHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Token Status"),
      ),
      body: Text('Home Page!!!!!!!!'),
    );
  }
}