import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: CalculatorScreen(
        toggleTheme: () {
          setState(() {
            _themeMode = _themeMode == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light;
          });
        },
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const CalculatorScreen({super.key, required this.toggleTheme});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  final List<String> buttons = [
    'C', '⌫', '%', '/',
    '7', '8', '9', '*',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '0', '.', '=', 
  ];

  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        _expression = '';
        _result = '';
      } else if (text == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (text == '=') {
        try {
          _result = _evaluate(_expression);
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _expression += text;
      }
    });
  }

  String _evaluate(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
    try {
      final parsed = expression.replaceAll('%', '*0.01');
      final result = double.parse(_calculate(parsed));
      return result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 2);
    } catch (_) {
      return 'Invalid';
    }
  }

  String _calculate(String exp) {
    try {
      final expn = exp.replaceAll('--', '+');
      final parser = RegExp(r'(\d+(?:\.\d+)?)|([+\-*/])');
      final tokens = parser.allMatches(expn).map((e) => e[0]!).toList();

      List<double> numbers = [];
      List<String> operators = [];

      for (String token in tokens) {
        if (RegExp(r'[+\-*/]').hasMatch(token)) {
          operators.add(token);
        } else {
          numbers.add(double.parse(token));
        }
      }

      while (operators.contains('*') || operators.contains('/')) {
        int i = operators.indexWhere((op) => op == '*' || op == '/');
        double res = operators[i] == '*'
            ? numbers[i] * numbers[i + 1]
            : numbers[i] / numbers[i + 1];
        numbers
          ..removeAt(i)
          ..removeAt(i)
          ..insert(i, res);
        operators.removeAt(i);
      }

      while (operators.isNotEmpty) {
        double res = operators[0] == '+'
            ? numbers[0] + numbers[1]
            : numbers[0] - numbers[1];
        numbers
          ..removeAt(0)
          ..removeAt(0)
          ..insert(0, res);
        operators.removeAt(0);
      }

      return numbers[0].toString();
    } catch (_) {
      return '0';
    }
  }

  Widget _buildButton(String text) {
    bool isOperator = ['%', '/', '*', '-', '+', '='].contains(text);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(22),
            backgroundColor: isOperator ? Colors.deepPurple : Colors.grey[200],
            foregroundColor: isOperator ? Colors.white : Colors.black,
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < buttons.length; i += 4) {
      rows.add(Row(
        children: List.generate(
          (i + 4 > buttons.length) ? buttons.length - i : 4,
          (j) => _buildButton(buttons[i + j]),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          ...rows,
        ],
      ),
    );
  }
}
