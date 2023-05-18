import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:latlong2/latlong.dart';
import 'package:polls/services/auth.dart';

class Poll {
  final String id;
  final String ownerID;
  final String question;
  final List<String> options;
  final Map<String, int> votes;
  final DateTime createdAt;
  final GeoPoint location;

  const Poll(
      {required this.id,
      required this.ownerID,
      required this.question,
      required this.options,
      required this.votes,
      required this.createdAt,
      required this.location});

  List<int> countVotes() {
    final count = List.filled(options.length, 0);
    for (final vote in votes.values) {
      count[vote]++;
    }
    return count;
  }

  bool hasVoted() => votes.containsKey(getUid());

  int milesFrom(LatLng here) => (const Distance())
      .as(LengthUnit.Mile, LatLng(location.latitude, location.longitude), here)
      .toInt();

  factory Poll.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Poll.fromData(doc.id, doc.data() ?? {});
  }

  factory Poll.fromData(String id, Map<String, dynamic> data) {
    return Poll(
      id: id,
      ownerID: data['ownerID'],
      question: data['question'],
      options: List<String>.from(data['options']),
      votes: Map<String, int>.from(data['votes']),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: data['location']['geopoint'],
    );
  }

  Future<int> numComments() async => (await FirebaseFirestore.instance
          .collection('polls')
          .doc(id)
          .collection('comments')
          .get())
      .size;

  Stream<List<Comment>> comments() =>
      getComments(FirebaseFirestore.instance.collection('polls').doc(id));
  Future<void> comment(String text) async => await addComment(
      FirebaseFirestore.instance.collection('polls').doc(id), text);
}

Stream<List<Poll>> getGlobalPolls() async* {
  final snapshots = FirebaseFirestore.instance
      .collection('polls')
      .where("local", isEqualTo: false)
      .snapshots();
  await for (final snapshot in snapshots) {
    yield [for (final doc in snapshot.docs) Poll.fromDoc(doc)]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}

// Get only polls within a certain distance in kilometers
Stream<List<Poll>> getLocalPolls(LatLng location, double distance) async* {
  final snapshots = Geoflutterfire()
      .collection(collectionRef: FirebaseFirestore.instance.collection('polls').where("local", isEqualTo: true))
      .within(
          center: GeoFirePoint(location.latitude, location.longitude),
          radius: distance,
          field: 'location');
  await for (final snapshot in snapshots) {
    yield [for (final doc in snapshot) Poll.fromDoc(doc)]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}

Future<List<Poll>> listPolls() async {
  final snapshots = await FirebaseFirestore.instance.collection('polls').get();
  return snapshots.docs.map((doc) => Poll.fromDoc(doc)).toList();
}

//read a specific poll
Future<Poll?> queryPoll(String id) async {
  final doc =
      await FirebaseFirestore.instance.collection('polls').doc(id).get();
  final data = doc.data();
  return data == null ? null : Poll.fromData(id, data);
}

Stream<Poll> subscribePoll(String id) async* {
  final snapshots =
      FirebaseFirestore.instance.collection('polls').doc(id).snapshots();
  await for (final snapshot in snapshots) {
    yield Poll.fromDoc(snapshot);
  }
}

// create a poll
Future<Poll?> addPoll(
    String initQuest, List<String> options, LatLng here, bool local) async {
  final geo = Geoflutterfire();
  final pollData = {
    'ownerID': getUid()!,
    'question': initQuest,
    'options': options,
    'votes': {},
    'createdAt': FieldValue.serverTimestamp(),
    'local': local,
    'location':
        geo.point(latitude: here.latitude, longitude: here.longitude).data,
  };
  final doc = await geo
      .collection(collectionRef: FirebaseFirestore.instance.collection('polls'))
      .add(pollData);
  return queryPoll(doc.id);
}

Future<bool> hasVoted(String id) async =>
    (await queryPoll(id))?.votes.containsKey(getUid()!) ?? false;

// Update a poll with a user vote
Future<Poll?> votePoll(String id, int choice) async {
  final poll = FirebaseFirestore.instance.collection('polls').doc(id);
  await poll.update({"votes.${getUid()!}": choice});
  return queryPoll(id);
}

// Delete a poll by id
// Returns an error message if the poll does not exist
// Returns null if the poll is successfully deleted
Future<String?> deletePoll(String id) async {
  return FirebaseFirestore.instance
      .collection('polls')
      .doc(id)
      .delete()
      .then((_) => null, onError: (e) => e);
}

class Comment {
  const Comment({
    required this.author,
    required this.createdAt,
    required this.content,
  });

  final String? author;
  final DateTime createdAt;
  final String content;

  factory Comment.fromData(Map<String, dynamic> data) => Comment(
        author: data['author'],
        createdAt:
            ((data['createdAt'] ?? Timestamp.now()) as Timestamp).toDate(),
        content: data['content'],
      );

  factory Comment.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      Comment.fromData(doc.data() ?? {});
}

Future<Comment?> addComment(
    DocumentReference<Map<String, dynamic>> parent, String comment) async {
  final commentData = {
    "author": getUid()!,
    'createdAt': FieldValue.serverTimestamp(),
    "content": comment,
  };
  final c = await parent.collection('comments').add(commentData);
  return getComment(parent, c.id);
}

Stream<List<Comment>> getComments(
    DocumentReference<Map<String, dynamic>> parent) async* {
  final snapshots = parent.collection('comments').snapshots();
  await for (final snapshot in snapshots) {
    yield [for (final doc in snapshot.docs) Comment.fromDoc(doc)]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }
}

Future<Comment?> getComment(
    DocumentReference<Map<String, dynamic>> parent, String id) async {
  final doc = await parent.collection('comments').doc(id).get();
  final data = doc.data();
  return data == null ? null : Comment.fromData(data);
}

Future<Comment?> deleteComment(
    DocumentReference<Map<String, dynamic>> parent, String id) async {
  return parent.collection('comments').doc(id).delete().then((_) => null, onError: (e) => e);
}
