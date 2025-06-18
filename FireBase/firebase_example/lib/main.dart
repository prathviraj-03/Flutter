import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_example/homescreen.dart';
import 'package:firebase_example/login_screen.dart';
import 'package:firebase_example/reset_password_screen.dart';
import 'package:firebase_example/signup_screen.dart';
import 'package:flutter/material.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyDTcUusAJwrn7oLEhb1SHP2e_3MCucScqI",
    authDomain: "fir-8827d.firebaseapp.com",
    projectId: "fir-8827d",
    storageBucket: "fir-8827d.firebasestorage.app",
    messagingSenderId: "944216900469",
    appId: "1:944216900469:web:439990cf68d82ba630893c") );
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp ({super.key});

  @override

  Widget build(BuildContext context){
    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null? HomeScreen(): LoginScreen(),
    );
  }
}