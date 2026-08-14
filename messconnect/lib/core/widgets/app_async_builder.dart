import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_error_text.dart';
import 'app_loading.dart';

/// A simple wrapper for [AsyncValue] that handles loading and error states
/// consistently across the app.
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
  final Widget Function(BuildContext context, Object error, StackTrace? stackTrace)? error;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (d) => data(context, d),
      loading: () => loading ?? const AppLoading(),
      error: (e, s) => error?.call(context, e, s) ?? Center(child: AppErrorText(e)),
    );
  }
}
