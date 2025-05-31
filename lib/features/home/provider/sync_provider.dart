import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/sync_service.dart';
import '../model/sync_result.dart';

final syncProvider =
    StateNotifierProvider<SyncNotifier, AsyncValue<SyncResult?>>((ref) {
  return SyncNotifier(ref);
});

class SyncNotifier extends StateNotifier<AsyncValue<SyncResult?>> {
  final Ref ref;
  SyncNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> sync() async {
    state = const AsyncValue.loading();
    try {
      final result = await ref.read(syncServiceProvider).sync();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
