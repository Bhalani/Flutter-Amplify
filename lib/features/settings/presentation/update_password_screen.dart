import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../main.dart';

class UpdatePasswordScreen extends ConsumerStatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  ConsumerState<UpdatePasswordScreen> createState() =>
      _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends ConsumerState<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await updatePasswordProvider(
        ref,
        _currentPasswordController.text,
        _newPasswordController.text,
      );
      if (mounted) {
        final message = ref.read(authStateProvider).message;
        showGentleSnackBar(
          context,
          message,
          type: SnackBarType.success,
        );
        GoRouter.of(context).go('/settings');
      }
    } catch (e) {
      if (mounted) {
        final message = ref.read(authStateProvider).message;
        showGentleSnackBar(
          context,
          message.isNotEmpty ? message : e.toString(),
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go('/settings'),
          tooltip: 'Back to Settings',
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Align(
        alignment: const Alignment(0, -0.4),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  decoration: getPlatformInputDecoration('Current Password'),
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter your current password'
                      : null,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: getPlatformInputDecoration('New Password'),
                  obscureText: true,
                  validator: Validators.password,
                  enabled: !_isLoading,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 4),
                Builder(
                  builder: (context) {
                    final strength = Validators.passwordStrength(
                        _newPasswordController.text);
                    Color strengthColor;
                    String strengthLabel;
                    if (strength < 0.4) {
                      strengthColor = Colors.red;
                      strengthLabel = 'Weak';
                    } else if (strength < 0.8) {
                      strengthColor = Colors.orange;
                      strengthLabel = 'Medium';
                    } else {
                      strengthColor = Colors.green;
                      strengthLabel = 'Strong';
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: strength,
                          backgroundColor: Colors.grey[300],
                          color: strengthColor,
                          minHeight: 5,
                        ),
                        Text('Password strength: $strengthLabel',
                            style:
                                TextStyle(color: strengthColor, fontSize: 12)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      getPlatformInputDecoration('Confirm New Password'),
                  obscureText: true,
                  validator: (value) => value != _newPasswordController.text
                      ? 'Passwords do not match'
                      : null,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updatePassword,
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Update Password'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
