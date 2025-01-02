import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ualo/screen/signin.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignIn(title: 'Flutter Login Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}
