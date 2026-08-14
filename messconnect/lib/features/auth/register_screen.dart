import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/user_profile.dart';
import 'auth_controller.dart';
import 'widgets/auth_shared.dart';

/// Email/password registration screen (PART 3).
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _messName = TextEditingController();
  final _contactNo = TextEditingController();
  
  UserRole _role = UserRole.student;

  void _submit() async {
    await ref.read(authControllerProvider.notifier).registerWithEmail(
          _email.text.trim(),
          _password.text,
          role: _role,
          messName: _role == UserRole.messOwner ? _messName.text.trim() : null,
          contactNo: _role == UserRole.messOwner ? _contactNo.text.trim() : null,
        );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _messName.dispose();
    _contactNo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final busy = state.isLoading;
    final theme = Theme.of(context);

    return AuthShared.scaffold(
      context: context,
      title: 'Create account',
      children: [
        const Text(
          'I am a:',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        SegmentedButton<UserRole>(
          segments: const [
            ButtonSegment(value: UserRole.student, label: Text('Student'), icon: Icon(Icons.person)),
            ButtonSegment(value: UserRole.messOwner, label: Text('Mess Owner'), icon: Icon(Icons.restaurant)),
          ],
          selected: {_role},
          onSelectionChanged: (val) => setState(() => _role = val.first),
        ),
        const SizedBox(height: 24),
        AuthShared.field(
          controller: _email,
          label: 'Email',
          hint: 'you@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        AuthShared.field(
          controller: _password,
          label: 'Password',
          obscure: true,
        ),
        if (_role == UserRole.messOwner) ...[
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFFDE7E0),
                  child: Icon(Icons.add_a_photo_outlined, color: Color(0xFFE8612C)),
                ),
                TextButton(onPressed: () {}, child: const Text('Add Mess Photo')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AuthShared.field(
            controller: _messName,
            label: 'Mess Name',
            hint: 'e.g. Tasty Meals Mess',
          ),
          AuthShared.field(
            controller: _contactNo,
            label: 'Contact Number',
            hint: 'e.g. +91 98765 43210',
            keyboardType: TextInputType.phone,
          ),
        ],
        AuthShared.errorText(state.error),
        AuthShared.submitButton(
          onPressed: busy ? null : _submit,
          label: busy ? 'Creating…' : 'Register',
        ),
        const SizedBox(height: 8),
        AuthShared.switchButton(
          context: context,
          label: 'Already have an account? Sign in',
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
