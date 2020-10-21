import 'package:flutter/material.dart';
import 'Mapping.dart';
import 'Authenthication.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PredictionApp());
}

class PredictionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'D11 Prediction App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MappingPage(
        auth: Auth(),
      ),
    );
  }
}
