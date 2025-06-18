import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(const PaletteApp());
}

class PaletteApp extends StatelessWidget {
  const PaletteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Palette Playground',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const PaletteGenerator(),
    );
  }
}

class PaletteGenerator extends StatefulWidget {
  const PaletteGenerator({super.key});

  @override
  State<PaletteGenerator> createState() => _PaletteGeneratorState();
}

class _PaletteGeneratorState extends State<PaletteGenerator> {
  final List<Color> _baseColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  List<Color> _currentPalette = [];
  final List<List<Color>> _savedPalettes = [];
  double _mixIntensity = 0.5;

  @override
  void initState() {
    super.initState();
    _generateRandomPalette();
  }

  void _generateRandomPalette() {
    setState(() {
      _currentPalette = List.generate(5, (index) {
        final random = _baseColors.toList()..shuffle();
        return random.first.withOpacity(0.8 + (0.2 * index / 5));
      });
    });
  }

  void _saveCurrentPalette() {
    setState(() {
      _savedPalettes.add(List.from(_currentPalette));
    });
  }

  void _mixColors() {
    setState(() {
      _currentPalette = _currentPalette.map((color) {
        final neighborIndex = (_currentPalette.indexOf(color) + 1) % _currentPalette.length;
        final neighborColor = _currentPalette[neighborIndex];
        return Color.lerp(color, neighborColor, _mixIntensity)!;
      }).toList();
    });
  }

  void _updateMixIntensity(double value) {
    setState(() {
      _mixIntensity = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Palette Playground'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateRandomPalette,
            tooltip: 'Generate new palette',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              constrained: false,
              child: Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: _currentPalette.mapIndexed((index, color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentPalette[index] = color.withOpacity(
                              (color.opacity + 0.1) % 1.0);
                        });
                      },
                      onLongPress: () {
                        setState(() {
                          _currentPalette[index] = _baseColors[
                          (_baseColors.indexOf(color) + 1) % _baseColors.length];
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '#${color.value.toRadixString(16).substring(2)}',
                            style: TextStyle(
                              color: color.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Slider(
                  value: _mixIntensity,
                  onChanged: _updateMixIntensity,
                  min: 0,
                  max: 1,
                  divisions: 10,
                  label: 'Mix Intensity: ${(_mixIntensity * 100).round()}%',
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _mixColors,
                      child: const Text('Mix Colors'),
                    ),
                    ElevatedButton(
                      onPressed: _saveCurrentPalette,
                      child: const Text('Save Palette'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_savedPalettes.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _savedPalettes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentPalette = List.from(_savedPalettes[index]);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: _savedPalettes[index].map((color) {
                          return Container(
                            width: 30,
                            height: 80,
                            color: color,
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}