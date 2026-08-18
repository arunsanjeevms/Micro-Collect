import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_state_widget.dart';
import 'skeleton_loader.dart';

/// The default way to render an `AsyncValue<T>` on a screen: loading shows a
/// skeleton, an error shows ErrorStateWidget with a retry action, and an
/// empty result (when [isEmpty] is supplied) shows [empty] instead of
/// [data]. List and detail screens should use this rather than an inline
/// `.when()`, so loading/empty/error states stay consistent across the app
/// instead of each screen inventing its own.
class AsyncValueView<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function()? loading;
  final Widget? empty;
  final bool Function(T data)? isEmpty;
  final VoidCallback? onRetry;

  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.empty,
    this.isEmpty,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: true,
      data: (value) {
        if (empty != null && isEmpty != null && isEmpty!(value)) {
          return empty!;
        }
        return data(value);
      },
      loading: () => loading?.call() ?? const ListSkeleton(),
      error: (error, _) => ErrorStateWidget(error: error, onRetry: onRetry),
    );
  }
}
