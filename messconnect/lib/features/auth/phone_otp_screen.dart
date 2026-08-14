import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_controller.dart';
import 'auth_repository.dart';
import 'widgets/auth_shared.dart';

/// Phone OTP sign-in screen (PART 3).
///
/// Enter a full E.164 number (e.g. +919999999999). On "Send code" Firebase
/// delivers an SMS; with a console "test phone number" the code is instant.
/// Submit the 6-digit SMS code to complete sign-in.
///
/// Note: phone auth on a real device needs the app's SHA-1 in the Firebase
/// console; the Android emulator works with test numbers without that step.
class PhoneOtpScreen extends ConsumerStatefulWidget {
  const PhoneOtpScreen({super.key});

  @override
  ConsumerState<PhoneOtpScreen> createState() => _PhoneOtpScreenState();
}

class _PhoneOtpScreenState extends ConsumerState<PhoneOtpScreen> {
  final _phone = TextEditingController(text: '+91');
  final _code = TextEditingController();

  String? _verificationId;
  Object? _error;
  bool _codeSent = false;

  void _sendCode() async {
    setState(() => _error = null);
    try {
      await ref.read(authRepositoryProvider).sendOtp(
        phoneNumber: _phone.text.trim(),
        timeout: const Duration(seconds: 60),
        onCodeSent: (verificationId, _) {
          setState(() {
            _verificationId = verificationId;
            _codeSent = true;
          });
        },
        onFailed: (e) => setState(() => _error = e),
        onAutoVerified: (_) {/* auto-retrieval handled by SDK */},
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e);
    }
  }

  void _submitCode() async {
    if (_verificationId == null) return;
    setState(() => _error = null);
    await ref.read(authControllerProvider.notifier).verifyOtp(
          _verificationId!,
          _code.text.trim(),
        );
  }

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final busy = state.isLoading;

    return AuthShared.scaffold(
      context: context,
      title: 'Sign in with phone',
      children: [
        AuthShared.field(
          controller: _phone,
          label: 'Phone number',
          hint: '+919999999999',
          keyboardType: TextInputType.phone,
        ),
        if (!_codeSent)
          AuthShared.submitButton(
            onPressed: busy ? null : _sendCode,
            label: busy ? 'Sending…' : 'Send code',
          )
        else ...[
          AuthShared.field(
            controller: _code,
            label: 'SMS code',
            keyboardType: TextInputType.number,
          ),
          AuthShared.submitButton(
            onPressed: busy ? null : _submitCode,
            label: busy ? 'Verifying…' : 'Verify & sign in',
          ),
        ],
        AuthShared.errorText(_error ?? state.error),
        const SizedBox(height: 8),
        AuthShared.switchButton(
          context: context,
          label: 'Use email instead',
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
