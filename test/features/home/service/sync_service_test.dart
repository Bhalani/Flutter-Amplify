import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth/features/home/service/sync_service.dart';
import 'package:mockito/mockito.dart';

class MockSyncService extends Mock implements SyncService {}

void main() {
  test('generateRandomParams returns valid params', () {
    final service = SyncService();
    final params = service.generateRandomParams();
    expect(params['first_name'], isNotEmpty);
    expect(params['last_name'], isNotEmpty);
    expect(params['email'], contains('@'));
  });
}
