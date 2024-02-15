import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location_sample_app/location_repository.dart';
import 'package:location_sample_app/location_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final initializeProvider = FutureProvider<void>((ref) async {
  final locationRepository = ref.read(locationRepositoryProvider);
  await locationRepository.permission();
  await Supabase.instance.client.auth.signInWithPassword(
    password: dotenv.env['SUPABASE_PASSWORD']!,
    email: dotenv.env['SUPABASE_EMAIL'],
  );
});

class PermissionGate extends HookConsumerWidget {
  const PermissionGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: ref.watch(initializeProvider.future),
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
