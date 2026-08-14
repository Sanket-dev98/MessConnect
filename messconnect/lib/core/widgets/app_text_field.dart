import 'package:flutter/material.dart';

/// Text input field with the app's Material 3 [InputDecoration] styling.
///
/// Wraps [TextFormField] so feature screens don't repeat the decoration.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscure = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, hintText: hint),
        obscureText: obscure,
        keyboardType: keyboardType,
      ),
    );
  }
}
