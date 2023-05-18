//  Created by Nicholas Eastmond on 9/26/22.

import 'package:flutter/material.dart';
import 'package:polls/polls_theme.dart';
import 'package:polls/screens/feed/feed_page.dart';
import 'package:polls/screens/polls/receive_poll_page.dart';
import 'package:polls/screens/profile/profile_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({
    super.key,
  });

  @override
  State<NavigationPage> createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  static double iconSize = 30;
  static double elevation = 2.5;

  int tabSelected = 0; // initially tab selected is poll feed

  @override
  Widget build(BuildContext context) {
    return PollsTheme(
      builder: (context, theme) => Scaffold(
        appBar: AppBar(
          //Top bar with app logo
          automaticallyImplyLeading: false,
          elevation: elevation,
          backgroundColor: theme.primaryColor,
          title: const Icon(
            Icons.bar_chart_rounded,
            size: 35,
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: BottomNavigationBar(
            //Navigation bar that contains feed, poll, and profile page icons
            elevation: 25,
            backgroundColor: theme.primaryColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: theme.unselectedWidgetColor.withAlpha(100),
            unselectedItemColor: theme.unselectedWidgetColor,
            currentIndex: tabSelected,
            onTap: (int tab) => setState(() => tabSelected = tab),
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  //Icons.table_rows_outlined,
                  Icons.assessment_outlined,
                  size: iconSize,
                ),
                label: 'Feed Page',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(
              //     Icons.assessment_outlined,
              //     size: iconSize,
              //   ),
              //   label: 'Poll Page',
              // ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  size: iconSize,
                ),
                label: 'Profile Page',
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: tabSelected,
          //const [FeedPage(), ReceivePollPage(), ProfilePage()],
          children: const [FeedPage(), ProfilePage()],
        ),
      ),
    );
  }
}
