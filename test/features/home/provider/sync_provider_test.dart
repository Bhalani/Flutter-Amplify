import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth/features/home/provider/sync_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('syncProvider exposes initial state', () async {
    final container = ProviderContainer();
    final state = container.read(syncProvider);
    expect(state, isNotNull);
  });
}
