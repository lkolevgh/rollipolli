import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:polls/polls_theme.dart';
import 'package:polls/screens/polls/expanded_poll.dart';
import 'package:polls/services/feed.dart';
import 'package:polls/services/user.dart';
import 'package:polls/widgets/dataVisualization/bar_graph.dart';
import 'package:polls/widgets/profile/profile_picture.dart';

class PollCard extends StatelessWidget {
  const PollCard({
    Key? key,
    required this.index,
    required this.poll,
    required this.currentLocation,
  }) : super(key: key);
  final Poll poll;
  final int index;
  final LatLng currentLocation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExpandedPollPage(
              pollID: poll.id,
            ),
          ),
        );
      },
      child: PollsTheme(builder: (context, theme) {
        return Container(
          decoration: BoxDecoration(
            color: index % 2 == 0
                ? theme.scaffoldBackgroundColor
                : MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? theme.primaryColor
                    : theme.cardColor,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 0),
            ],
          ),
          //height: 105,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    StreamBuilder<User>(
                      stream: subscribeUser(poll.ownerID),
                      builder: (context, snapshot) {
                        return MainProfileCircleWidget(
                          emoji: snapshot.data?.emoji ?? defaultEmoji,
                          fillColor: snapshot.data?.innerColor ??
                              Color(defaultInnerColor),
                          borderColor: snapshot.data?.outerColor ??
                              Color(defaultOuterColor),
                          size: 35,
                          width: 2.5,
                          emojiSize: 17.5,
                        );
                      },
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 260,
                      //color: Colors.grey.shade900,
                      child: Text(
                        poll.question,
                        style: GoogleFonts.zillaSlab(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          shadows: <Shadow>[
                            Shadow(
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 15,
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? const Color.fromARGB(255, 0, 0, 0)
                                      : const Color.fromARGB(0, 0, 0, 0),
                            ),
                          ],
                          color: MediaQuery.of(context).platformBrightness ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: BarGraph(
                          initalDisplayData: poll.hasVoted(),
                          numBars: poll.options.length,
                          height: 40,
                          width: 40,
                          minHeight: 5,
                          counters: poll.countVotes(),
                          spacing: 4,
                          circleBorder: 3),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(
                      width: 65,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.5),
                      child: FutureBuilder<int>(
                          future: poll.numComments(),
                          builder: (context, snapshot) {
                            return Text(
                              "${snapshot.data ?? 0}",
                              style: GoogleFonts.zillaSlab(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w500,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 15,
                                      color: MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.dark
                                          ? const Color.fromARGB(255, 0, 0, 0)
                                          : const Color.fromARGB(0, 0, 0, 0),
                                    ),
                                  ],
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white),
                            );
                          }),
                    ),
                    const SizedBox(
                      width: 1.75,
                    ),
                    Icon(
                      Icons.message_rounded,
                      size: 17.5,
                      color: theme.indicatorColor,
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.5),
                      child: Text(
                        poll.votes.length.toString(),
                        style: GoogleFonts.zillaSlab(
                            fontSize: 17.5,
                            fontWeight: FontWeight.w500,
                            shadows: <Shadow>[
                              Shadow(
                                offset: const Offset(0.0, 0.0),
                                blurRadius: 15,
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? const Color.fromARGB(255, 0, 0, 0)
                                        : const Color.fromARGB(0, 0, 0, 0),
                              ),
                            ],
                            color: MediaQuery.of(context).platformBrightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 1.75,
                    ),
                    Icon(
                      Icons.people_rounded,
                      size: 23,
                      color: theme.indicatorColor,
                    ),
                    const SizedBox(
                      width: 27.5,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        pollText(),
                        style: GoogleFonts.zillaSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            shadows: <Shadow>[
                              Shadow(
                                offset: const Offset(0.0, 0.0),
                                blurRadius: 15,
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? const Color.fromARGB(255, 0, 0, 0)
                                        : const Color.fromARGB(0, 0, 0, 0),
                              ),
                            ],
                            color: MediaQuery.of(context).platformBrightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String pollText() {
    final since = DateTime.now().difference(poll.createdAt);
    final pair = since.inMinutes < 60
        ? MapEntry(since.inMinutes, "min")
        : since.inHours < 24
            ? MapEntry(since.inHours, "hrs")
            : MapEntry(since.inDays, "days");
    return "${pair.key} ${pair.value} | ~${poll.milesFrom(currentLocation)}mi";
  }
}
