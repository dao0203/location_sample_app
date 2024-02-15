import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location_sample_app/location_repository.dart';
import 'package:location_sample_app/location_state.dart';

class LocationScreen extends HookConsumerWidget {
  const LocationScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            location.when(
              data: (data) => Column(
                children: [
                  Text('Latitude: ${data.latitude}'),
                  Text('Longitude: ${data.longitude}'),
                  ElevatedButton(
                    onPressed: () async {
                      await ref
                          .watch(locationRepositoryProvider)
                          .updateLocation(data);
                    },
                    child: const Text('位置情報を送信する'),
                  ),
                ],
              ),
              error: (error, stackTrace) => Text('Error: $error'),
              loading: () => const CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
