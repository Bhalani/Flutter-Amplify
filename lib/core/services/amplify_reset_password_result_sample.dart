// This file is for reference only. It shows how Amplify.Auth.resetPassword works.
// Remove or ignore in production.
import 'package:amplify_flutter/amplify_flutter.dart';

Future<void> resetPasswordExample(String email) async {
  final result = await Amplify.Auth.resetPassword(username: email);
  print('isPasswordReset: \\${result.isPasswordReset}');
  print('nextStep: \\${result.nextStep.updateStep}');
  print('codeDeliveryDetails: \\${result.nextStep.codeDeliveryDetails}');
}
