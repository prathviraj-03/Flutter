import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Welcome to second", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
