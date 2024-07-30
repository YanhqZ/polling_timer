import 'package:flutter/material.dart';

import 'pages/feature_page.dart';
import 'pages/verification_code_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('PollingTimer Demo'),
      ),
      body: ListView(
        children: <Widget>[
          Card.outlined(
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const FeaturePage();
                }));
              },
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Feature',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          Card.outlined(
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const VerificationCodePage();
                }));
              },
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Verification Code',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ].expand((element) => [const SizedBox(height: 16), element]).toList(),
      ),
    );
  }
}
