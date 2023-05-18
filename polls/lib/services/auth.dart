import 'package:firebase_auth/firebase_auth.dart';

Future<void> signIn(String email, String password) async =>
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

// Sign Up
Future<void> signUp(String email, String password) async =>
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

// Delete account
// Future<void> deleteAccount(String email, String password) async {
//   await FirebaseAuth.instance
//       .createUserWithEmailAndPassword(email: email, password: password);
// }

void signOut() async => await FirebaseAuth.instance.signOut();
String? getUid() => FirebaseAuth.instance.currentUser?.uid;
String? getEmail() => FirebaseAuth.instance.currentUser?.email;
String? getDisplayName() => FirebaseAuth.instance.currentUser?.displayName;
String? getPhotoUrl() => FirebaseAuth.instance.currentUser?.photoURL;
void setDisplayName(String name) async =>
    await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
