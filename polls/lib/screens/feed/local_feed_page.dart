//  Created by Nicholas Eastmond on 10/12/22.

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:polls/polls_theme.dart';
import 'package:polls/services/feed.dart';
import 'package:polls/widgets/feed/poll_card.dart';

import 'helper.dart';

const _distanceInKm = 8.04672;
double _kmToMi(double km) => km * 0.62137;

class LocalFeedPage extends StatelessWidget {
  const LocalFeedPage({
    required this.location,
    super.key,
  });
  final LatLng location;

  @override
  Widget build(BuildContext context) {
    return PollsTheme(builder: (context, theme) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            Positioned(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    spreadRadius: 7),
                              ]),
                          height: 85,
                          child: FlutterMap(
                            options: MapOptions(
                              zoom: 10,
                              center: location,
                            ),
                            layers: [
                              TileLayerOptions(
                                backgroundColor: Colors.white,
                                retinaMode: true,
                                urlTemplate:
                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c'],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 12.5,
                          left: 25,
                          child: Text(
                            style: GoogleFonts.zillaSlab(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade200,
                              shadows: <Shadow>[
                                const Shadow(
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 15,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            ),
                            "Local Polls",
                          ),
                        ),
                        Positioned(
                          bottom: 12.5,
                          right: 25,
                          child: Text(
                            style: GoogleFonts.zillaSlab(
                              fontSize: 17.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade200,
                              shadows: <Shadow>[
                                const Shadow(
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 15,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            ),
                            "Radius: ${_kmToMi(_distanceInKm).round()} mi",
                          ),
                        ),
                        FutureBuilder<List<Placemark>>(
                            future: placemarkLocation(location),
                            builder: (context, snapshot) {
                              return Positioned(
                                bottom: 12.5,
                                left: 25,
                                child: Text(
                                  style: GoogleFonts.zillaSlab(
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade200,
                                    shadows: <Shadow>[
                                      const Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 15,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ],
                                  ),
                                  "${snapshot.data?.first.locality ?? 'Loading...'} 📍",
                                ),
                              );
                            }),
                      ],
                    ),
                    StreamBuilder(
                      stream: getLocalPolls(location, _distanceInKm), // 5km
                      builder: (context, polls) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: polls.data?.length ?? 0,
                          itemBuilder: (_, index) => PollCard(
                            currentLocation: location,
                            poll: polls.data![index],
                            index: index,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
