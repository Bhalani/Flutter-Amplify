import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/ui_constants.dart';
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
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Color _getStrengthColor(double strength) {
    if (strength < 0.4) return UIConstants.dangerColor;
    if (strength < 0.8) return UIConstants.warningColor;
    return UIConstants.successColor;
  }

  String _getStrengthLabel(double strength) {
    if (strength < 0.4) return 'Weak';
    if (strength < 0.8) return 'Medium';
    return 'Strong';
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
    final strength = Validators.passwordStrength(_newPasswordController.text);
    final strengthColor = _getStrengthColor(strength);
    final strengthLabel = _getStrengthLabel(strength);

    return Scaffold(
      backgroundColor: UIConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Update Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go('/settings'),
          tooltip: 'Back to Settings',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spaceMd, // 16dp
            vertical: UIConstants.spaceLg, // 24dp
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructional text only - AppBar already says "Update Password"
              Text(
                'Enter your current password and choose a new one',
                style: UIConstants.bodyStyle,
              ),

              const SizedBox(height: UIConstants.spaceLg), // 24dp

              // Form Card
              Container(
                padding: const EdgeInsets.all(UIConstants.spaceMd), // 16dp
                decoration: UIConstants.cardDecoration,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _currentPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureCurrentPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() => _obscureCurrentPassword =
                                  !_obscureCurrentPassword);
                            },
                          ),
                        ),
                        obscureText: _obscureCurrentPassword,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter your current password'
                            : null,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: UIConstants.spaceMd), // 16dp
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNewPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() =>
                                  _obscureNewPassword = !_obscureNewPassword);
                            },
                          ),
                        ),
                        obscureText: _obscureNewPassword,
                        validator: Validators.password,
                        enabled: !_isLoading,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: UIConstants.spaceSm), // 8dp
                      // Password strength indicator
                      ClipRRect(
                        borderRadius: UIConstants.borderRadiusXs,
                        child: LinearProgressIndicator(
                          value: strength,
                          backgroundColor: UIConstants.dividerColor,
                          color: strengthColor,
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: UIConstants.spaceXs), // 4dp
                      Text(
                        'Password strength: $strengthLabel',
                        style: TextStyle(
                          color: strengthColor,
                          fontSize: UIConstants.tinyTextSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: UIConstants.spaceMd), // 16dp
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() => _obscureConfirmPassword =
                                  !_obscureConfirmPassword);
                            },
                          ),
                        ),
                        obscureText: _obscureConfirmPassword,
                        validator: (value) =>
                            value != _newPasswordController.text
                                ? 'Passwords do not match'
                                : null,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: UIConstants.spaceLg), // 24dp
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _updatePassword,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text('Update Password'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
