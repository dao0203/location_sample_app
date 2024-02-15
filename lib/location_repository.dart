import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location_sample_app/location.dart';

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl();
});

abstract interface class LocationRepository {
  Future<void> permission();
  Future<Location> getLocation();
}

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<Location> getLocation() async {
    return Geolocator.getCurrentPosition().then((position) {
      return Location(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    });
  }

  @override
  Future<void> permission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (await Geolocator.checkPermission() ==
        LocationPermission.deniedForever) {
      return Future.error("Location permission denied forever");
    }
  }
}
