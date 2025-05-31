import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/sync_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncProvider);
    final notifier = ref.read(syncProvider.notifier);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Welcome to home page!',
            style: TextStyle(fontFamily: 'Lato', fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: syncState.isLoading ? null : () => notifier.sync(),
            child: syncState.isLoading
                ? const CircularProgressIndicator()
                : const Text('Sync'),
          ),
          const SizedBox(height: 24),
          syncState.when(
            data: (result) => result != null
                ? Text('Hello Mr. ${result.firstName} ${result.lastName}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold))
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (e, _) =>
                Text('Error: $e', style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
