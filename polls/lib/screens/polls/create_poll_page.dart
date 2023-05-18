import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:polls/polls_theme.dart';
import 'package:polls/widgets/dataVisualization/bar_graph.dart';
import 'package:polls/services/feed.dart';

class CreatePollPage extends StatefulWidget {
  const CreatePollPage(
      {super.key,
      required this.location,
      required this.global,
      required this.local});
  final LatLng location;
  final bool local;
  final bool global;

  @override
  State<CreatePollPage> createState() => CreatePollPageState();
}

class CreatePollPageState extends State<CreatePollPage> {
  TextEditingController pollQuestionController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<TextEditingController> pollChoices = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  int numBars = 5;

  @override
  Widget build(BuildContext context) {
    return PollsTheme(builder: (context, theme) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          title: Text(
            widget.local == true && widget.global == true
                ? "New Poll"
                : widget.local == true
                    ? "New Local Poll"
                    : "New Global Poll",
            style: GoogleFonts.zillaSlab(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 17.5),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          ));
                        });
                    debugPrint("Creating Poll");
                    if (widget.local && widget.global) {
                      addPoll(
                        pollQuestionController.text,
                        pollChoices
                            .sublist(0, numBars)
                            .map((controller) => controller.text)
                            .toList(),
                        widget.location,
                        true,
                      ).then((p) {
                        if (p != null) {
                          addPoll(
                            pollQuestionController.text,
                            pollChoices
                                .sublist(0, numBars)
                                .map((controller) => controller.text)
                                .toList(),
                            widget.location,
                            false,
                          ).then((s) {
                            if (s != null) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: theme.primaryColor,
                                  content: Text(
                                    'Failed to add second Poll',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.zillaSlab(
                                      fontSize: 17.5,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }
                          });
                        } else {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: theme.primaryColor,
                              content: Text(
                                'Failed to add first Poll',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.zillaSlab(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                      });
                    } else {
                      addPoll(
                        pollQuestionController.text,
                        pollChoices
                            .sublist(0, numBars)
                            .map((controller) => controller.text)
                            .toList(),
                        widget.location,
                        widget.local,
                      ).then((p) {
                        Navigator.of(context).pop();
                        if (p != null) {
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: theme.primaryColor,
                              content: Text(
                                'Failed to add Poll',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.zillaSlab(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                      });
                    }
                  },
                  child: const Icon(
                    Icons.done_rounded,
                    size: 30.0,
                  ),
                )),
          ],
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 32,
                child: TextField(
                  controller: pollQuestionController,
                  textInputAction: TextInputAction.done,
                  //keyboardType: TextInputType.name,
                  style: GoogleFonts.zillaSlab(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                  onChanged: (s) {},
                  minLines: 1,
                  maxLines: 2,
                  //maxLength: 60,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                    floatingLabelStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    fillColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.white
                        : Colors.black,
                    labelText: "Poll Question",
                    //hintText:,
                    labelStyle: GoogleFonts.zillaSlab(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    focusColor: Colors.white,
                    suffixIcon: Icon(
                      Icons.edit_outlined,
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: MediaQuery.of(context).platformBrightness ==
                                  Brightness.light
                              ? Colors.grey
                              : Colors.white,
                          width: 0.33),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 0.33),
                    ),
                    border: const UnderlineInputBorder(),
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
                    numBars: numBars,
                    height: 230,
                    width: 230,
                    spacing: 20,
                    minHeight: 15,
                    counters: const [35, 70, 100, 70, 35],
                    circleBorder: 30,
                  ),
                  //  BarGraph(
                  //   numBars: numBars,
                  //   height: 260,
                  //   width: 260,
                  //   //spacing: (30 + (10 - numBars)).toDouble(),
                  //   largest: [40, 70, 100, 70, 40]
                  //       .sublist(0, numBars)
                  //       .reduce(max),
                  //   spacing: 20,
                  //   counters: const [40, 70, 100, 70, 40],
                  //   circleBorder: 15,
                  //   displayData: true,
                  // ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10,
                          offset: Offset.fromDirection(pi / 2, 2))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (numBars > 2) {
                            setState(() => numBars--);
                          }
                          scrollController.animateTo(
                            numBars > 2
                                ? scrollController.position.maxScrollExtent -
                                    100
                                : 0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          // padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset.fromDirection(pi / 2, 2))
                              ],
                              shape: BoxShape.circle,
                              color: theme.secondaryHeaderColor),
                          child: const Icon(
                            Icons.remove,
                            size: 27,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (numBars < 5) {
                            setState(() => numBars++);
                          }
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          // padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset.fromDirection(pi / 2, 2))
                              ],
                              shape: BoxShape.circle,
                              color: theme.secondaryHeaderColor),
                          child: const Icon(
                            Icons.add,
                            size: 27,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Colors.red,
                  Colors.blue,
                  Colors.orange,
                  Colors.green,
                  Colors.deepPurple
                ]
                    .sublist(0, numBars)
                    .asMap()
                    .entries
                    .map(
                      (e) => SizedBox(
                        height: 100,
                        child: PollChoiceWidget(
                          controller: pollChoices[e.key],
                          color: e.value,
                          index: e.key,
                          visible: e.key < numBars,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      );
    });
  }
}

class PollChoiceWidget extends StatelessWidget {
  const PollChoiceWidget({
    Key? key,
    required this.controller,
    required this.index,
    required this.visible,
    required this.color,
  }) : super(key: key);

  final TextEditingController controller;
  final int index;
  final bool visible;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: visible ? 100 : 0,
        decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
                color: Colors.black54,
                blurRadius: 10,
                offset: Offset.fromDirection(pi / 2, 2))
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              style: GoogleFonts.zillaSlab(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textInputAction: TextInputAction.done,
              controller: controller,
              minLines: 1,
              maxLines: 10,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.black.withAlpha(75)),
                hintText: "Enter Poll Choice ${index + 1}",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                alignLabelWithHint: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                filled: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
