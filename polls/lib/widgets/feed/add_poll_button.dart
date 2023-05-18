import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:polls/polls_theme.dart';
import 'package:polls/screens/polls/create_poll_page.dart';

class AddPollButton extends StatelessWidget {
  const AddPollButton({super.key, required this.location});
  final LatLng location;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      elevation: 3,
      position: PopupMenuPosition.over,
      offset: Offset.fromDirection(pi / 2, -90),
      child: PollsTheme(builder: (context, theme) {
        return Container(
          height: 70,
          width: 70,
          // padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset.fromDirection(pi / 2, 2))
          ], shape: BoxShape.circle, color: theme.unselectedWidgetColor),
          child: const Icon(
            Icons.add_chart_rounded,
            size: 30,
            color: Color.fromARGB(255, 67, 67, 67),
          ),
        );
      }),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(
                width: 15,
              ),
              Text(
                "Create Local Poll",
                style: GoogleFonts.zillaSlab(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              const Icon(Icons.map_outlined),
              const SizedBox(
                width: 15,
              ),
              Text(
                "Create Global Poll",
                style: GoogleFonts.zillaSlab(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            children: [
              const Icon(Icons.done_all),
              const SizedBox(
                width: 15,
              ),
              Text(
                "Create Both",
                style: GoogleFonts.zillaSlab(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (result) {
        if (result == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreatePollPage(
                location: location,
                local: true,
                global: false,
              ),
            ),
          );
        } else if (result == 2) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreatePollPage(
                  location: location, local: false, global: false),
            ),
          );
        } else if (result == 3) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  CreatePollPage(location: location, local: true, global: true),
            ),
          );
        }
      },
    );
  }
}
