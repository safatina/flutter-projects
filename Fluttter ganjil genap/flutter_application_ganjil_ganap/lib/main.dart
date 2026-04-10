import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter Kelipatan 3 + Ganjil Genap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Counter Kelipatan 3 + Ganjil Genap'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _maxLimit = 20;

  void _incrementCounter() {
    setState(() {
      if (_counter < _maxLimit) {
        _counter++;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  String get numberType {
    if (_counter % 2 == 0) {
      return "Genap";
    } else {
      return "Ganjil";
    }
  }

  String get multipleOfThree {
    if (_counter != 0 && _counter % 3 == 0) {
      return "Ya";
    } else {
      return "Tidak";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$_counter",
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Jenis Bilangan: $numberType",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              "Kelipatan 3: $multipleOfThree",
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetCounter,
              child: const Text("Reset"),
            ),
            const SizedBox(height: 10),
            Text("Batas Maksimum: $_maxLimit"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}