import 'package:flutter/material.dart';

void main() => runApp(const FlashcardApp());

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcards',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const FlashcardScreen(),
    );
  }
}

class Flashcard {
  final String front;
  final String back;

  Flashcard({required this.front, required this.back});
}

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final List<Flashcard> flashcards = [
    Flashcard(front: "Aberration", back: "A deviation from what is normal"),
    Flashcard(front: "Loquacious", back: "Very talkative"),
    Flashcard(front: "Ephemeral", back: "Lasting a very short time"),
    Flashcard(front: "Ubiquitous", back: "Present everywhere"),
    Flashcard(front: "Sagacious", back: "Wise; having keen perception"),
  ];

  int _currentIndex = 0;
  bool _showBack = false;

  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % flashcards.length;
      _showBack = false;
    });
  }

  void _prevCard() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + flashcards.length) % flashcards.length;
      _showBack = false;
    });
  }

  void _flipCard() {
    setState(() {
      _showBack = !_showBack;
    });
  }

  @override
  Widget build(BuildContext context) {
    final flashcard = flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard App'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _flipCard,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  _showBack ? flashcard.back : flashcard.front,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text("Previous"),
                onPressed: _prevCard,
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Next"),
                onPressed: _nextCard,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
