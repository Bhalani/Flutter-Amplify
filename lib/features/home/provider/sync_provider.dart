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

  Future<String?> syncAndGetRedirectUrl() async {
    return await ref.read(syncServiceProvider).syncAndGetRedirectUrl();
  }

  Future<Map<String, String>?> syncAndGetUrls() async {
    try {
      return await ref.read(syncServiceProvider).syncAndGetUrls();
    } catch (e) {
      return null;
    }
  }
}

final syncWebViewCloseProvider = StateProvider<bool>((ref) => false);
