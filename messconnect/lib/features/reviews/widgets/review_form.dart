import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/utils/snackbar.dart';
import '../../../core/widgets/app_button.dart';
import '../providers/review_provider.dart';

/// Modal bottom sheet for posting a new verified review (PART 8).
///
/// Requires a valid subscriptionId (active/expired/cancelled subscription to
/// the mess). The backend enforces the "subscribers only" rule.
class ReviewForm extends ConsumerStatefulWidget {
  const ReviewForm({
    super.key,
    required this.messId,
    required this.subscriptionId,
    this.onSubmitted,
  });

  final String messId;
  final String subscriptionId;
  final VoidCallback? onSubmitted;

  @override
  ConsumerState<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends ConsumerState<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();

  int _taste = 3;
  int _hygiene = 3;
  int _quality = 3;
  int _punctuality = 3;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref
          .read(reviewCreateProvider.notifier)
          .create(
            messId: widget.messId,
            subscriptionId: widget.subscriptionId,
            ratingTaste: _taste,
            ratingHygiene: _hygiene,
            ratingQuality: _quality,
            ratingPunctuality: _punctuality,
            comment: _commentController.text.trim(),
          );
      if (mounted) {
        Navigator.pop(context);
        showSnackBar(context, 'Review posted successfully!');
        widget.onSubmitted?.call();
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveLayout.horizontalPadding(context);
    final theme = Theme.of(context);
    final creating = ref.watch(reviewCreateProvider).isLoading;

    return Padding(
      padding: EdgeInsets.only(
        left: padding,
        right: padding,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Write a Review', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Only subscribers (active or previous) can review. '
                'Ratings are 1–5 stars.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              _RatingSelector(
                label: 'Taste',
                value: _taste,
                onChanged: (v) => setState(() => _taste = v),
              ),
              _RatingSelector(
                label: 'Hygiene',
                value: _hygiene,
                onChanged: (v) => setState(() => _hygiene = v),
              ),
              _RatingSelector(
                label: 'Quality',
                value: _quality,
                onChanged: (v) => setState(() => _quality = v),
              ),
              _RatingSelector(
                label: 'Punctuality',
                value: _punctuality,
                onChanged: (v) => setState(() => _punctuality = v),
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Comment (optional)',
                  hintText: 'Share your experience...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                maxLength: 2000,
                validator: (v) {
                  if (v != null && v.length > 2000) {
                    return 'Comment must be 2000 characters or less';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: creating ? 'Posting...' : 'Post Review',
                  onPressed: creating ? null : _submit,
                  busy: creating,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingSelector extends StatelessWidget {
  const _RatingSelector({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (i) {
              final star = i + 1;
              return Expanded(
                child: InkWell(
                  onTap: () => onChanged(star),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Icon(
                      star <= value ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}