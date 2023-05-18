import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polls/widgets/profile/profile_picture.dart';
import 'package:flutter/cupertino.dart';

import 'package:polls/services/auth.dart';
import 'package:polls/polls_theme.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({
    required this.profilePicture,
    required this.callback,
    Key? key,
  }) : super(key: key);

  final MainProfileCircleWidget profilePicture;
  final Function callback;

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return PollsTheme(builder: (context, theme) {
      return IconButton(
        icon: Icon(
          Icons.settings_rounded,
          size: 30,
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        iconSize: 35,
        onPressed: () async {
          mainSettingsMenu(context, theme);
        },
      );
    });
  }

  Future<dynamic> mainSettingsMenu(BuildContext context, ThemeData theme) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(30.0),
          height: 440,
          color: const Color.fromARGB(255, 233, 232, 232).withAlpha(0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Colors.grey.shade700,
                  child: ListTile(
                    title: Text(
                      'Change Profile  🔧',
                      style: GoogleFonts.zillaSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.callback();
                    },
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Colors.grey.shade700,
                  child: ListTile(
                    title: Text(
                      'App Appearance  🌞 🌚',
                      style: GoogleFonts.zillaSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      appAppearanceMenu(context, theme);
                    },
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Colors.grey.shade700,
                  child: ListTile(
                    title: Text(
                      'Privacy Policy  🔍',
                      style: GoogleFonts.zillaSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    onTap: null,
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Colors.grey.shade700,
                  child: ListTile(
                    title: Text(
                      'Terms of service  👨‍⚖️',
                      style: GoogleFonts.zillaSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    onTap: null,
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Colors.red,
                  child: ListTile(
                    title: Text(
                      'Exit Rolli Polli  👋',
                      style: GoogleFonts.zillaSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      logOutWarning(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> logOutWarning(BuildContext context) {
    return showCupertinoModalPopup<void>(
      context: context,
      barrierColor: Colors.grey.shade900.withOpacity(0.7),
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Log Out'),
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
            onPressed: () {
              signOut();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<dynamic> appAppearanceMenu(BuildContext context, ThemeData theme) {
    return showModalBottomSheet(
      isDismissible: false,
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(30.0),
          height: 440,
          color: const Color.fromARGB(255, 233, 232, 232).withAlpha(0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // App Appearance
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: MediaQuery.of(context).platformBrightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                          splashRadius: 20,
                          onPressed: () {
                            Navigator.of(context).pop();
                            mainSettingsMenu(context, theme);
                          }),
                      Flexible(
                        child: Text(
                          "App Appearance",
                          style: GoogleFonts.zillaSlab(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Opacity(
                        opacity: 0.0,
                        child: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: null,
                        ),
                      ),
                    ]),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Colors.grey.shade700,
                  child: ListTile(
                    title: Text(
                      'Device  🖥️',
                      style: GoogleFonts.zillaSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    onTap: PollsTheme.setAuto,
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Colors.grey.shade700,
                  child: ListTile(
                    title: Text(
                      'Light Mode  🌞',
                      style: GoogleFonts.zillaSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    onTap: PollsTheme.setLight,
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Colors.grey.shade700,
                  child: ListTile(
                    title: Text(
                      'Dark Mode  🌚',
                      style: GoogleFonts.zillaSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    onTap: PollsTheme.setDark,
                  ),
                ),
                const SizedBox(
                  height: 140.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SettingsMenuHeadingWidget extends StatelessWidget {
  const SettingsMenuHeadingWidget({
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconButton(
          icon: const Icon(Icons.arrow_back),
          splashRadius: 20,
          onPressed: () {
            Navigator.of(context).pop();
          }),
      Flexible(
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const Opacity(
        opacity: 0.0,
        child: IconButton(
          icon: Icon(Icons.clear),
          onPressed: null,
        ),
      ),
    ]);
  }
}
