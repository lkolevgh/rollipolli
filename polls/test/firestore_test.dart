import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:polls/firebase_options.dart';
import 'package:polls/services/feed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TestApp());
}

class TestApp extends StatefulWidget {
  const TestApp({super.key});
  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  void initState() async {
    final firestore = FirebaseFirestore.instance;
    firestore.useFirestoreEmulator('localhost', 8080);
    await addPoll("Example Question", ["Example Answer"], LatLng(0, 0), false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, title: 'Test App', home: Scaffold());
  }
}
