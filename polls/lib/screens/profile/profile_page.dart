import 'package:flutter/material.dart';
import 'package:polls/services/auth.dart';
import 'package:polls/services/user.dart';
import 'package:polls/widgets/profile/profile_picture.dart';
import 'package:emojis/emoji.dart';
import 'package:polls/widgets/profile/profile_points.dart';
import 'package:polls/widgets/profile/profile_settings.dart';

import '../../polls_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  List<Emoji> eList = (Emoji.byGroup(EmojiGroup.foodDrink)).toList();
  List<String> emojiList = [];
  Stream<User> user = subscribeUser(getUid()!);

  ProfilePageState() {
    for (var element in eList) {
      emojiList.add(element.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: user,
        builder: (context, snapshot) {
          return PollsTheme(builder: (context, theme) {
            return Scaffold(
                backgroundColor: theme.scaffoldBackgroundColor,
                body: Stack(alignment: Alignment.center, children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: SettingsWidget(
                      profilePicture: MainProfileCircleWidget(
                        fillColor:
                            snapshot.data?.innerColor ?? Colors.pink.shade50,
                        borderColor:
                            snapshot.data?.outerColor ?? Colors.pink.shade800,
                        size: 175,
                        emoji: snapshot.data?.emoji ?? defaultEmoji,
                        width: 5,
                        emojiSize: 70,
                        emojiListUnlocked: emojiList,
                        colorListUnlocked: colorList,
                      ),
                      callback: () =>
                          showBottomSheet(context, subscribeUser(getUid()!)),
                    ),
                  ),
                  Positioned(
                    top: 75,
                    child: GestureDetector(
                        child: MainProfileCircleWidget(
                          fillColor:
                              snapshot.data?.innerColor ?? Colors.pink.shade50,
                          borderColor:
                              snapshot.data?.outerColor ?? Colors.pink.shade800,
                          size: 200,
                          emoji: snapshot.data?.emoji ?? defaultEmoji,
                          width: 6,
                          emojiSize: 70,
                          emojiListUnlocked: emojiList,
                          colorListUnlocked: colorList,
                        ),
                        onTap: () =>
                            showBottomSheet(context, subscribeUser(getUid()!))),
                  ),
                  Positioned(
                    top: 300,
                    child:
                        ProfileScoreWidget(score: snapshot.data?.points ?? 0),
                  ),
                ]));
          });
        });
  }

  Future<dynamic> showBottomSheet(BuildContext context, Stream<User> stream) {
    return showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return StreamBuilder<User>(
              stream: stream,
              builder: (context, snapshot) {
                return Container(
                  padding: const EdgeInsets.all(30.0),
                  height: 800,
                  color: const Color.fromARGB(255, 233, 232, 232).withAlpha(0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                            child: MainProfileCircleWidget(
                          fillColor:
                              snapshot.data?.innerColor ?? Colors.pink.shade50,
                          borderColor:
                              snapshot.data?.outerColor ?? Colors.pink.shade800,
                          size: 175,
                          emoji: snapshot.data?.emoji ?? defaultEmoji,
                          width: 5,
                          emojiSize: 70,
                        )),
                        const SettingsMenuHeadingWidget(
                          title: "Inner Profile Color",
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 150.0,
                            child: SizedBox(
                              height: 125.0,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                physics: const ScrollPhysics(),
                                children: List.generate(colorList.length,
                                    (int index) {
                                  return Card(
                                    color: colorList[index],
                                    surfaceTintColor: Colors.black,
                                    child: InkWell(
                                      onTap: () => setState(() {
                                        setInnerColor(colorList[index]);
                                      }),
                                      child: const SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: 250.0,
                            height: 25.0,
                            alignment: Alignment.center,
                            child: const Text("Outer Profile Color",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))),
                        Expanded(
                          child: SizedBox(
                            height: 150.0,
                            child: SizedBox(
                              height: 125.0,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(emojiList.length,
                                    (int index) {
                                  return Card(
                                    color: colorList[index],
                                    surfaceTintColor: Colors.black,
                                    child: InkWell(
                                      onTap: () => setState(() {
                                        setOuterColor(colorList[index]);
                                      }),
                                      child: const SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: 150.0,
                            height: 25.0,
                            alignment: Alignment.center,
                            child: const Text("Profile Picture",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))),
                        Expanded(
                          child: SizedBox(
                            height: 200.0,
                            child: SizedBox(
                              height: 80.0,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(emojiList.length,
                                    (int index) {
                                  return Card(
                                    color: Colors.white,
                                    shadowColor: Colors.black,
                                    child: InkWell(
                                      onTap: () => setState(() {
                                        setEmoji(emojiList[index]);
                                      }),
                                      child: Container(
                                        width: 60.0,
                                        height: 40.0,
                                        alignment: Alignment.center,
                                        child: Text(
                                          emojiList[index],
                                          style: const TextStyle(fontSize: 45),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}

const baseColor = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.purple,
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.lime,
  Colors.amber,
  Colors.brown,
  Colors.indigo,
];

final colorList = [
  Colors.red.shade50,
  Colors.red.shade100,
  Colors.red.shade200,
  Colors.red.shade300,
  Colors.red.shade400,
  Colors.red,
  Colors.red.shade500,
  Colors.red.shade600,
  Colors.red.shade700,
  Colors.red.shade800,
  Colors.red.shade900,
  Colors.orange.shade50,
  Colors.orange.shade100,
  Colors.orange.shade200,
  Colors.orange.shade300,
  Colors.orange.shade400,
  Colors.orange,
  Colors.orange.shade500,
  Colors.orange.shade600,
  Colors.orange.shade700,
  Colors.orange.shade800,
  Colors.orange.shade900,
  Colors.yellow.shade50,
  Colors.yellow.shade100,
  Colors.yellow.shade200,
  Colors.yellow.shade300,
  Colors.yellow.shade400,
  Colors.yellow,
  Colors.yellow.shade500,
  Colors.yellow.shade600,
  Colors.yellow.shade700,
  Colors.yellow.shade800,
  Colors.yellow.shade900,
  Colors.green.shade50,
  Colors.green.shade100,
  Colors.green.shade200,
  Colors.green.shade300,
  Colors.green.shade400,
  Colors.green,
  Colors.green.shade500,
  Colors.green.shade600,
  Colors.green.shade700,
  Colors.green.shade800,
  Colors.green.shade900,
  Colors.blue.shade50,
  Colors.blue.shade100,
  Colors.blue.shade200,
  Colors.blue.shade300,
  Colors.blue.shade400,
  Colors.blue,
  Colors.blue.shade500,
  Colors.blue.shade600,
  Colors.blue.shade700,
  Colors.blue.shade800,
  Colors.blue.shade900,
  Colors.purple.shade50,
  Colors.purple.shade100,
  Colors.purple.shade200,
  Colors.purple.shade300,
  Colors.purple.shade400,
  Colors.purple,
  Colors.purple.shade500,
  Colors.purple.shade600,
  Colors.purple.shade700,
  Colors.purple.shade800,
  Colors.purple.shade900,
  Colors.pink.shade50,
  Colors.pink.shade100,
  Colors.pink.shade200,
  Colors.pink.shade300,
  Colors.pink.shade400,
  Colors.pink,
  Colors.pink.shade500,
  Colors.pink.shade600,
  Colors.pink.shade700,
  Colors.pink.shade800,
  Colors.pink.shade900,
  Colors.teal.shade50,
  Colors.teal.shade100,
  Colors.teal.shade200,
  Colors.teal.shade300,
  Colors.teal.shade400,
  Colors.teal,
  Colors.teal.shade500,
  Colors.teal.shade600,
  Colors.teal.shade700,
  Colors.teal.shade800,
  Colors.teal.shade900,
  Colors.cyan.shade50,
  Colors.cyan.shade100,
  Colors.cyan.shade200,
  Colors.cyan.shade300,
  Colors.cyan.shade400,
  Colors.cyan,
  Colors.cyan.shade500,
  Colors.cyan.shade600,
  Colors.cyan.shade700,
  Colors.cyan.shade800,
  Colors.cyan.shade900,
  Colors.lime.shade50,
  Colors.lime.shade100,
  Colors.lime.shade200,
  Colors.lime.shade300,
  Colors.lime.shade400,
  Colors.lime,
  Colors.lime.shade500,
  Colors.lime.shade600,
  Colors.lime.shade700,
  Colors.lime.shade800,
  Colors.lime.shade900,
  Colors.amber.shade50,
  Colors.amber.shade100,
  Colors.amber.shade200,
  Colors.amber.shade300,
  Colors.amber.shade400,
  Colors.amber,
  Colors.amber.shade500,
  Colors.amber.shade600,
  Colors.amber.shade700,
  Colors.amber.shade800,
  Colors.amber.shade900,
  Colors.brown.shade50,
  Colors.brown.shade100,
  Colors.brown.shade200,
  Colors.brown.shade300,
  Colors.brown.shade400,
  Colors.brown,
  Colors.brown.shade500,
  Colors.brown.shade600,
  Colors.brown.shade700,
  Colors.brown.shade800,
  Colors.brown.shade900,
  Colors.indigo.shade50,
  Colors.indigo.shade100,
  Colors.indigo.shade200,
  Colors.indigo.shade300,
  Colors.indigo.shade400,
  Colors.indigo,
  Colors.indigo.shade500,
  Colors.indigo.shade600,
  Colors.indigo.shade700,
  Colors.indigo.shade800,
  Colors.indigo.shade900,
];
