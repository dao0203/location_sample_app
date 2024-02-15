import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location_sample_app/location_repository.dart';
import 'package:location_sample_app/location_screen.dart';

class PermissionGate extends HookConsumerWidget {
  const PermissionGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationRepository = ref.watch(locationRepositoryProvider);
    return FutureBuilder(
        future: locationRepository.permission(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const LocationScreen();
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Permission'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
