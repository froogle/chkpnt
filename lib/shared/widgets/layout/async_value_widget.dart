import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';

/// Reusable widget for handling AsyncValue states consistently
///
/// This widget provides a standard way to handle loading, error, and data states
/// for all async providers in the app. It's particularly useful for streaming
/// providers that can have loading and error states.
class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget? loading;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final bool skipLoadingOnRefresh;
  final bool skipLoadingOnReload;
  final bool skipError;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.skipLoadingOnRefresh = true,
    this.skipLoadingOnReload = false,
    this.skipError = false,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipLoadingOnReload: skipLoadingOnReload,
      skipError: skipError,
      data: data,
      loading: () => loading ?? _buildDefaultLoading(),
      error: (err, stack) => error?.call(err, stack) ?? _buildDefaultError(err),
    );
  }

  Widget _buildDefaultLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildDefaultError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(
                fontSize: 14,
                color:
                    AppColors.expandIcon, // Use explicit colour for Android 13
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Simplified version for list data
class AsyncValueListWidget<T> extends StatelessWidget {
  final AsyncValue<List<T>> value;
  final Widget Function(List<T> items) data;
  final Widget? loading;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final Widget? empty;

  const AsyncValueListWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.empty,
  });

  @override
  Widget build(BuildContext context) {
    return AsyncValueWidget<List<T>>(
      value: value,
      data: (items) {
        if (items.isEmpty && empty != null) {
          return empty!;
        }
        return data(items);
      },
      loading: loading,
      error: error,
    );
  }
}

/// Widget for handling async operations with retry functionality
class AsyncValueRetryWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final Widget? loading;
  final String? errorMessage;

  const AsyncValueRetryWidget({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.loading,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AsyncValueWidget<T>(
      value: value,
      data: data,
      loading: loading,
      error: (error, stackTrace) => _buildErrorWithRetry(context, error),
    );
  }

  Widget _buildErrorWithRetry(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? 'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(
                fontSize: 14,
                color:
                    AppColors.expandIcon, // Use explicit colour for Android 13
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
