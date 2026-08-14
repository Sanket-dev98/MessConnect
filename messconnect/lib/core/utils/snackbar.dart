import 'package:flutter/material.dart';

/// Snackbar helpers for transient feedback (network results, errors).
///
/// Centralised so the messaging/coloring stays consistent app-wide.
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

/// Shows an error snackbar, converting [error] to a readable string.
void showErrorSnackBar(BuildContext context, Object? error) {
  final message = switch (error) {
    final e when e != null => e.toString(),
    _ => 'Something went wrong',
  };
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red),
  );
}
