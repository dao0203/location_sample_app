import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location_sample_app/location.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl();
});

abstract interface class LocationRepository {
  Future<void> permission();
  Future<Location> getLocation();
  Stream<Location> watchLocation();
  Future<void> updateLocation(Location location);
}

class LocationRepositoryImpl implements LocationRepository {
  final _client = Supabase.instance.client;
  @override
  Future<Location> getLocation() async {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((position) {
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

  @override
  Future<void> updateLocation(Location location) async {
    debugPrint('updateLocation');
    await _client.from('locations').update({
      'latitude': location.latitude,
      'longitude': location.longitude,
    }).eq('id', 'b8a58138-0728-4bab-b7e9-109a6df0af79');
  }

  @override
  Stream<Location> watchLocation() {
    return Geolocator.getPositionStream().map((event) {
      return Location(
        latitude: event.latitude,
        longitude: event.longitude,
      );
    });
  }
}
