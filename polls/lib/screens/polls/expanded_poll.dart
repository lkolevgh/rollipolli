import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polls/polls_theme.dart';
import 'package:polls/services/auth.dart';
import 'package:polls/services/report.dart';
import 'package:polls/services/user.dart';
import 'package:polls/widgets/dataVisualization/bar_graph.dart';
import 'package:polls/services/feed.dart';

import 'package:polls/widgets/profile/profile_picture.dart';

class ExpandedPollPage extends StatefulWidget {
  const ExpandedPollPage({
    super.key,
    required this.pollID,
  });
  final String pollID;

  @override
  State<ExpandedPollPage> createState() => ExpandedPollPageState();
}

class ExpandedPollPageState extends State<ExpandedPollPage> {
  ScrollController scrollController = ScrollController();
  late Stream<Poll> poll;

  bool displayResults = false;

  @override
  void initState() {
    super.initState();
    poll = subscribePoll(widget.pollID);
    hasVoted(widget.pollID).then((value) {
      setState(() => displayResults = value);
    });
  }

  Future<void> voteOnPoll(int vote) async {
    debugPrint('voting on $vote');
    bool voted = await hasVoted(widget.pollID);
    if (voted) {
      debugPrint('user already voted');
    } else if (vote != -1) {
      debugPrint('user not voted');
      await votePoll(widget.pollID, vote);
    }
    setState(() {
      displayResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Poll>(
        stream: poll,
        builder: (context, snapshot) {
          return PollsTheme(builder: (context, theme) {
            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: AppBar(
                leading: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: BackButton(
                    color: Colors.white,
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: StreamBuilder<User>(
                      stream: subscribeUser(
                          snapshot.data?.ownerID ?? "invalid-user-id"),
                      builder: (context, snapshot) {
                        return MainProfileCircleWidget(
                          fillColor: snapshot.data?.innerColor ??
                              Color(defaultInnerColor),
                          borderColor: snapshot.data?.outerColor ??
                              Color(defaultOuterColor),
                          size: 32,
                          width: 2.5,
                          emoji: snapshot.data?.emoji ?? defaultEmoji,
                          emojiSize: 16,
                        );
                      }),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          backgroundColor: theme.scaffoldBackgroundColor,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0)),
                          ),
                          elevation: 2,
                          builder: (BuildContext context) {
                            return CommentSectionPage(snapshot.data!);
                          },
                        );
                      },
                      child: const Icon(
                        Icons.message_outlined,
                        size: 26.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          backgroundColor: theme.scaffoldBackgroundColor,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0)),
                          ),
                          elevation: 2,
                          builder: (BuildContext context) {
                            return DeleteReportMenu(
                                delete:
                                    (snapshot.data?.ownerID ?? "") == getUid(),
                                callback: () async {
                                  if ((snapshot.data?.ownerID ?? "") ==
                                      getUid()) {
                                    await deletePoll(snapshot.data?.id ?? '');
                                    debugPrint('deleted poll');
                                  } else {
                                    await reportPoll(snapshot.data?.id ?? '',
                                        'Inappropriate Poll', snapshot.data!);
                                    debugPrint('reported poll');
                                  }
                                });
                          },
                        );
                      },
                      child: const Icon(
                        Icons.more_horiz,
                        size: 26.0,
                      ),
                    ),
                  ),
                ],
                elevation: 5,
                backgroundColor: theme.primaryColor,
              ),
              body: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    // Text(
                    //   "This is the poll question",
                    //     style: GoogleFonts.zillaSlab(
                    //       fontSize: 22,
                    //       fontWeight: FontWeight.w600,
                    //       color: MediaQuery.of(context).platformBrightness ==
                    //               Brightness.light
                    //           ? Colors.black
                    //           : Colors.white,
                    // ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          snapshot.data?.question ?? "",
                          style: GoogleFonts.zillaSlab(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: MediaQuery.of(context).platformBrightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 300,
                      color: theme.scaffoldBackgroundColor,
                      child: SizedBox(
                        height: 230,
                        child: BarGraph(
                          numBars: snapshot.data?.options.length ?? 0,
                          minHeight: 15,
                          height: 230,
                          width: 230,
                          spacing: 20,
                          counters: snapshot.data?.countVotes() ?? [],
                          circleBorder: 30,
                          initalDisplayData: displayResults,
                        ),
                        //  BarGraph(
                        //   numBars: widget.numBars,
                        //   height: 260,
                        //   width: 260,
                        //   //spacing: (30 + (10 - widget.numBars)).toDouble(),
                        //   largest: [40, 70, 100, 70, 40]
                        //       .sublist(0, widget.numBars)
                        //       .reduce(max),
                        //   spacing: 20,
                        //   counters: const [40, 70, 100, 70, 40],
                        //   circleBorder: 15,
                        //   displayData: true,
                        // ),
                      ),
                    ),
                    Column(
                      children: [
                        for (int i = 0;
                            i < (snapshot.data?.options.length ?? 0);
                            i++)
                          GestureDetector(
                            onTap: () => {voteOnPoll(i)},
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              height: 100,
                              decoration: BoxDecoration(
                                color: [
                                  Colors.red,
                                  Colors.blue,
                                  Colors.orange,
                                  Colors.green,
                                  Colors.deepPurple
                                ][i % 5],
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black54,
                                      blurRadius: 10,
                                      offset: Offset.fromDirection(pi / 2, 2))
                                ],
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 35,
                                          right: 0),
                                      child: Text(
                                        snapshot.data!.options[i],
                                        style: GoogleFonts.zillaSlab(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}

class CommentSectionPage extends StatefulWidget {
  const CommentSectionPage(
    this.poll, {
    Key? key,
  }) : super(key: key);

  final Poll poll;

  @override
  State<CommentSectionPage> createState() => _CommentSectionPageState();
}

class _CommentSectionPageState extends State<CommentSectionPage> {
  final commentTextEditorController = TextEditingController();
  late Stream<List<Comment>> stream;

  @override
  void initState() {
    super.initState();
    stream = widget.poll.comments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  StreamBuilder(
                      stream: stream,
                      builder: (_, comments) {
                        return ListView.builder(
                          reverse: true,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: comments.data?.length ?? 0,
                          itemBuilder: (_, index) =>
                              CommentCard(index, comments.data![index]),
                        );
                      }),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: PollsTheme(
                builder: (context, theme) {
                  return Container(
                    height: 110,
                    color: theme.scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 90,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              style: GoogleFonts.zillaSlab(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              textInputAction: TextInputAction.done,
                              controller: commentTextEditorController,
                              minLines: 1,
                              maxLines: 10,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                fillColor:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.light
                                        ? Colors.grey.shade200
                                        : Colors.grey.shade900,
                                hintStyle: TextStyle(
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.light
                                      ? Colors.black.withAlpha(75)
                                      : Colors.grey.shade800,
                                ),
                                hintText: "Add a Comment",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                alignLabelWithHint: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 16),
                                filled: true,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 30,
                            child: GestureDetector(
                              onTap: (() async {
                                await widget.poll
                                    .comment(commentTextEditorController.text);
                                commentTextEditorController.clear();
                              }),
                              child: Icon(
                                Icons.send,
                                size: 27.5,
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.light
                                        ? Colors.black.withAlpha(75)
                                        : Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentCard extends StatefulWidget {
  const CommentCard(
    this.index,
    this.comment, {
    Key? key,
  }) : super(key: key);
  final Comment comment;
  final int index;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  late Stream<User> userStream;
  @override
  void initState() {
    super.initState();
    userStream = subscribeUser(widget.comment.author!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.index % 2 == 0
          ? const Color.fromRGBO(0, 0, 0, 0)
          : const Color.fromARGB(30, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                StreamBuilder<User>(
                    stream: userStream,
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
                    }),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text(
                    widget.comment.content,
                    style: GoogleFonts.zillaSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        shadows: <Shadow>[
                          Shadow(
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 15,
                            color: MediaQuery.of(context).platformBrightness ==
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
                const SizedBox(width: 15),
                const Spacer()
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 65,
                ),
                Text(
                  DateTime.now()
                              .difference(widget.comment.createdAt)
                              .inMinutes <
                          60
                      ? "${DateTime.now().difference(widget.comment.createdAt).inMinutes} min ago"
                      : DateTime.now()
                                  .difference(widget.comment.createdAt)
                                  .inHours <
                              24
                          ? "${DateTime.now().difference(widget.comment.createdAt).inHours} hrs ago"
                          : "${DateTime.now().difference(widget.comment.createdAt).inDays} days ago",
                  style: GoogleFonts.zillaSlab(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      shadows: <Shadow>[
                        Shadow(
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 15,
                          color: MediaQuery.of(context).platformBrightness ==
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
                const Spacer(),
                PollsTheme(builder: (context, theme) {
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        backgroundColor: theme.scaffoldBackgroundColor,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25.0)),
                        ),
                        elevation: 2,
                        builder: (BuildContext context) {
                          return DeleteReportMenu(
                            delete: widget.comment.author == getUid(),
                            callback: () async {
                              if (widget.comment.author == getUid()) {
                                debugPrint('deleting comment');
                              } else {
                                await reportComment(
                                    widget.comment.author!,
                                    'Inappropriate Comment',
                                    widget.comment.content);
                                debugPrint('reporting comment');
                              }
                            },
                          );
                        },
                      );
                    },
                    child: Icon(Icons.more_horiz,
                        size: 20,
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white),
                  );
                }),
                const SizedBox(
                  width: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DeleteReportMenu extends StatelessWidget {
  const DeleteReportMenu(
      {Key? key, required this.delete, required this.callback})
      : super(key: key);
  final bool delete;
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      padding: const EdgeInsets.all(30.0),
      color: const Color.fromARGB(255, 233, 232, 232).withAlpha(0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              color: Colors.red,
              child: ListTile(
                title: Center(
                  child: Text(
                    delete ? "Delete" : "Report",
                    style: GoogleFonts.zillaSlab(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  logOutWarning(context);
                },
              ),
            ),
            Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              color: Colors.grey.shade700,
              child: ListTile(
                title: Center(
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.zillaSlab(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logOutWarning(BuildContext context) {
    return showCupertinoModalPopup<void>(
      context: context,
      barrierColor: Colors.grey.shade900.withOpacity(0.7),
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(delete ? 'Delete Post?' : 'Report Post?'),
        content: const Text('Are you sure?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              callback();
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              var snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    delete ? "Deleted Post" : "Reporting Post",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.zillaSlab(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
