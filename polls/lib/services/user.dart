import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:polls/services/auth.dart';

const defaultEmoji = "🤪";
final defaultInnerColor = Colors.blue.value;
final defaultOuterColor = Colors.red.value;

class User {
  final String id;
  final String emoji;
  final Color innerColor;
  final Color outerColor;
  final int points;

  const User({
    required this.id,
    required this.emoji,
    required this.innerColor,
    required this.outerColor,
    required this.points,
  });

  factory User.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return User.fromData(doc.id, doc.data() ?? {});
  }

  factory User.fromData(String id, Map<String, dynamic> data) {
    return User(
      id: id,
      emoji: data['emoji'] ?? defaultEmoji,
      innerColor: Color(data['innerColor'] ?? defaultInnerColor),
      outerColor: Color(data['outerColor'] ?? defaultOuterColor),
      points: data['points'] ?? 0,
    );
  }
}

Future<User> getUser(String uid) async => User.fromDoc(
    await FirebaseFirestore.instance.collection("users").doc(uid).get());

Future<User> setEmoji(String emoji) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(getUid()!)
      .set({"emoji": emoji}, SetOptions(merge: true));
  return getUser(getUid()!);
}

Future<User> setInnerColor(Color color) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(getUid()!)
      .set({"innerColor": color.value}, SetOptions(merge: true));
  return getUser(getUid()!);
}

Future<User> setOuterColor(Color color) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(getUid()!)
      .set({"outerColor": color.value}, SetOptions(merge: true));
  return getUser(getUid()!);
}

Stream<User> subscribeUser(String uid) async* {
  final snapshots =
      FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  await for (final snapshot in snapshots) {
    yield User.fromDoc(snapshot);
  }
}
