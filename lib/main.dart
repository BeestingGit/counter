import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    // Provide the model to all widgets within the app. We're using
    // ChangeNotifierProvider because that's a simple way to rebuild
    // widgets when a model changes. We could also just use
    // Provider, but then we would have to listen to Counter ourselves.
    //
    // Read Provider's docs to learn about all the available providers.
    ChangeNotifierProvider(
      // Initialize the model in the builder. That way, Provider
      // can own Counter's lifecycle, making sure to call `dispose`
      // when not needed anymore.
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;
void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(
        Rect.fromCenter(
          center: screen!.frame.center,
          width: windowWidth,
          height: windowHeight,
        ),
      );
    });
  }
}

/// Simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`. [Counter] does
/// _not_ depend on Provider.
class Counter with ChangeNotifier {
  int value = 0;
  void increment() {
    value += 1;
    notifyListeners();
  }
}

// Defining the Age Milestones
String getAgeMilestones(int age) {
  if (age <= 12) return "You're a child!";
  if (age <= 19) return "Teenager time!";
  if (age <= 30) return "You're a young adult!";
  if (age <= 50) return "You're an adult!";
  return "Golden years!";
}

// Change Background Color Alongside Age Messages
Color getBackgroundColor(int age) {
  if (age <= 12) return Colors.lightBlue;
  if (age <= 19) return Colors.lightGreen;
  if (age <= 30) return Colors.yellow;
  if (age <= 50) return Colors.orange;
  return Colors.grey;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age Counter')),
      body: Consumer<Counter>(
        builder: (context, counter, child) {
          return Container(
            color: getBackgroundColor(counter.value),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I am ${counter.value} years old',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    getAgeMilestones(counter.value),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Slider(
                    value: counter.value.toDouble(),
                    min: 0,
                    max: 99,
                    divisions: 99,
                    label: counter.value.toString(),
                    onChanged: (double newValue) {
                      counter.value = newValue.toInt();
                      counter.notifyListeners();
                    },
                  ),
                  LinearProgressIndicator(
                    value: counter.value / 99,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      counter.value <= 33
                          ? Colors.green
                          : counter.value <= 67
                          ? Colors.yellow
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var counter = context.read<Counter>();
          counter.increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
