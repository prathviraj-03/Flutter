import 'package:flutter/material.dart';

void main() {
  runApp(const IDCardApp());
}

class IDCardApp extends StatelessWidget {
  const IDCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student ID Card',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.amber[200],
        ),
      ),
      home: const IDCardScreen(),
    );
  }
}

class IDCardScreen extends StatefulWidget {
  const IDCardScreen({super.key});

  @override
  State<IDCardScreen> createState() => _IDCardScreenState();
}

class _IDCardScreenState extends State<IDCardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: const Text("Master Student ID Card"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Card(
            elevation: 12,
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.deepPurple, thickness: 1.5),
                  const SizedBox(height: 8),
                  buildInfoRow("Name", "Prathviraj Acharya"),
                  buildInfoRow(
                      "Course", "MCA - Master of Computer Applications"),
                  buildInfoRow("USN", "NNM24MC109"),
                  buildInfoRow("Year of Adm", "2024 - 2025"),
                  buildInfoRow("Date of Birth", "15-Aug-2001"),
                  buildInfoRow("Blood Group", "A+"),
                  buildInfoRow("Address", "Attur Karkala, Karnataka, India"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
