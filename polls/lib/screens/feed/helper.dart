import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

Future<List<Placemark>> placemarkLocation(LatLng location) async {
  try {
    return await placemarkFromCoordinates(
        location.latitude, location.longitude);
  } catch (e) {
    return [Placemark()];
  }
}
