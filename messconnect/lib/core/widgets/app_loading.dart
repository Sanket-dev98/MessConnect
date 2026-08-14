import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_error_text.dart';

/// Centered spinner used as a standalone loading placeholder.
class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

/// Renders an [AsyncValue] in its loading / error / data states.
///
/// Used by the list/detail screens arriving in Parts 6–10 so each only has to
/// supply the `data` builder. [loading] and [error] fall back to sensible
/// defaults when omitted.
class AppAsyncBuilder<T> extends StatelessWidget {
  const AppAsyncBuilder({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) data;
  final Widget? loading;
  final Widget Function(BuildContext context, Object error)? error;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => loading ?? const AppLoading(),
      error: (e, _) =>
          error?.call(context, e) ?? AppErrorText(e, key: const Key('async-error')),
      data: (d) => data(context, d),
    );
  }
}
