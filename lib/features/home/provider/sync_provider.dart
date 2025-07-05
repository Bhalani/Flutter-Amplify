import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/sync_service.dart';

final syncUrlProvider = FutureProvider<String?>((ref) async {
  return await ref.read(syncServiceProvider).syncAndGetRedirectUrl();
});
