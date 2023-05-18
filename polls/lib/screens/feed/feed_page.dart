//  Created by Nicholas Eastmond on 9/26/22.

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:polls/polls_theme.dart';
import 'package:polls/screens/feed/global_feed_page.dart';
import 'package:polls/screens/feed/local_feed_page.dart';
import 'package:polls/widgets/feed/add_poll_button.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({
    super.key,
  });

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  LatLng location = LatLng(0, 0);

  Future<void> allowLocation() async {
    final service = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await service.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await service.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await service.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await service.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    final locationData = await service.getLocation();
    setState(() =>
        location = LatLng(locationData.latitude!, locationData.longitude!));

    debugPrint("User is in $location");
  }

  @override
  void initState() {
    super.initState();
    allowLocation();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: PollsTheme(
        builder: (context, theme) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: theme.secondaryHeaderColor,
              bottom: TabBar(
                indicatorColor: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? Colors.white
                    : Colors.black,
                tabs: const [
                  Tab(icon: Icon(Icons.location_on_outlined)),
                  Tab(icon: Icon(Icons.map_outlined)),
                ],
              ),
            ),
            body: Stack(children: [
              TabBarView(
                children: [
                  LocalFeedPage(location: location),
                  GlobalFeedPage(location: location),
                ],
              ),
              Positioned(
                bottom: 25,
                right: 25,
                child: AddPollButton(location: location),
              ),
            ]),
          );
        },
      ),
    );
  }
}
