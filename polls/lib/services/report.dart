import 'package:cloud_firestore/cloud_firestore.dart';
import 'feed.dart';

// -- for creating a report for inappropriate polls --
Future<void> reportPoll(String pollid, String comment, Poll reportedPoll) async {
  Map pollData = {
    'question': reportedPoll.question,
    'options': reportedPoll.options
  };
  final reportData = {
    'id': pollid,
    'comment': comment,
    'reportedPoll': pollData,
  };
  await FirebaseFirestore.instance.collection('reportsPolls').add(reportData);
}

// -- for creating a report for inappropriate comments --
// id = associated id of user that supposingly needs to be blocked
// comment = the comment that a user describing whats wrong with the message
// reportedMes = the actual message of interest that the user reported upon
Future<void> reportComment(
    String id, String comment, String reportedCom) async {
  final reportData = {
    'id': id,
    'comment': comment,
    'reportedCom': reportedCom,
  };
  await FirebaseFirestore.instance.collection('reportsComments').add(reportData);
}


// create a poll
// Future<Poll?> addPoll(
//     String initQuest, List<String> options, LatLng here, bool local) async {
//   final geo = Geoflutterfire();
//   final pollData = {
//     'ownerID': getUid()!,
//     'question': initQuest,
//     'options': options,
//     'votes': {},
//     'createdAt': FieldValue.serverTimestamp(),
//     'local': local,
//     'location':
//         geo.point(latitude: here.latitude, longitude: here.longitude).data,
//   };
//   final doc = await geo
//       .collection(collectionRef: FirebaseFirestore.instance.collection('polls'))
//       .add(pollData);
//   return queryPoll(doc.id);
// }

// //read a specific poll
// Future<Poll?> queryPoll(String id) async {
//   final doc =
//       await FirebaseFirestore.instance.collection('polls').doc(id).get();
//   final data = doc.data();
//   return data == null ? null : Poll.fromData(id, data);
// }
