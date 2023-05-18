import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScoreWidget extends StatelessWidget {
  const ProfileScoreWidget({
    Key? key,
    required this.score,
  }) : super(key: key);
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(2.0),
        width: 260,
        margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
        decoration: BoxDecoration(
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.grey.shade100
              : Colors.grey.shade900,
          border: Border.all(
            color: MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.grey.shade200
                : const Color.fromARGB(255, 50, 50, 50),
            width: 6,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: Text(
                "Rollipoints 🏅",
                style: GoogleFonts.zillaSlab(
                  fontSize: 23,
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
                      : Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              // Image.asset(
              //   // <a href="https://www.flaticon.com/free-icons/medal" title="medal icons">Medal icons created by Vectors Market - Flaticon</a>
              //   'assets/medal.png',
              //   width: 40,
              //   height: 40,
              // ),
              //const SizedBox(width: 5),
              SizedBox(
                width: 170,
                child: Center(
                  child: AutoSizeText(
                    '$score',
                    style: GoogleFonts.zillaSlab(
                      fontSize: 30,
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
                          : Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                "Create and Vote on polls to get more Rollipoints!",
                style: GoogleFonts.zillaSlab(
                  fontSize: 16,
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
                      : Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ));
  }
}
