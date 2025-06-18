import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello world!"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("HELLO WORLD!!", style: GoogleFonts.lato()),
            ElevatedButton(
              onPressed: () {
                print("Button pressed!");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 6, 84, 230), // Background color
                foregroundColor: Colors.white, // Text/Icon color
                shadowColor: Colors.black, // Shadow color
                elevation: 10, // Shadow depth
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 1,
                ), // Padding
                shape: RoundedRectangleBorder(
                  // Custom shape
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text("Click me! "),
            ),
            TextField()
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 122, 240),
    );
  }
}
