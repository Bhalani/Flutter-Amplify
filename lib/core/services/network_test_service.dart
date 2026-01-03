import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class NetworkTestService {
  static Future<bool> testAPIGatewayConnectivity() async {
    const testUrl =
        'https://rh1k6y8abj.execute-api.ap-south-1.amazonaws.com/dev/health';

    debugPrint('🧪 Testing API Gateway connectivity...');
    debugPrint('🌐 Test URL: $testUrl');

    try {
      final response = await http.get(
        Uri.parse(testUrl),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      debugPrint('✅ API Gateway Response: ${response.statusCode}');
      debugPrint('📋 Response Headers: ${response.headers}');

      // Any response (even 404) means connectivity is working
      return true;
    } catch (e) {
      debugPrint('❌ API Gateway Test Failed: $e');
      debugPrint('🔍 Error Type: ${e.runtimeType}');

      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection failed')) {
        debugPrint('🚨 Network connectivity issue detected');
      } else if (e.toString().contains('TimeoutException')) {
        debugPrint('⏰ Connection timeout - API Gateway unreachable');
      }

      return false;
    }
  }

  static Future<bool> testBasicConnectivity() async {
    debugPrint('🧪 Testing basic internet connectivity...');

    try {
      final response = await http.get(
        Uri.parse('https://httpbin.org/get'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 5));

      debugPrint('✅ Basic connectivity: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Basic connectivity failed: $e');
      return false;
    }
  }
}
