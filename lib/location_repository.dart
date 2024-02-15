import 'package:location_sample_app/location.dart';

abstract interface class LocationRepository {
  Future<Location> getLocation();
}
