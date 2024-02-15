import 'package:location_sample_app/location.dart';
import 'package:location_sample_app/location_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_state.g.dart';

@riverpod
class LocationState extends _$LocationState {
  @override
  Future<Location> build() {
    return ref.watch(locationRepositoryProvider).getLocation();
  }
}
