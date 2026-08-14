import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Inline error text used across forms and async data states.
///
/// [FirebaseAuthException] is rendered via its message/code so users see a
/// readable reason rather than a raw exception string.
class AppErrorText extends StatelessWidget {
  const AppErrorText(this.error, {super.key});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    if (error == null) return const SizedBox.shrink();
    final message = switch (error) {
      FirebaseAuthException e => e.message ?? e.code,
      _ => error.toString(),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}
