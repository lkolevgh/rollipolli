//import 'package:firebase_core/firebase_core.dart';
import 'package:polls/wrapper.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const PollsApp());
}

class PollsApp extends StatelessWidget {
  const PollsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rolli Polli',
      home: Wrapper(),
    );
  }
}
