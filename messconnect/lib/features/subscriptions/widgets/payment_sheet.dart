import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/utils/snackbar.dart';
import '../../../core/widgets/app_button.dart';
import '../models/subscription_plan.dart';
import '../providers/subscription_provider.dart';

/// Bottom-sheet that simulates a UPI payment for a selected plan (PART 9).
///
/// On confirm: creates a subscription, then pays (simulated gateway). Shows the
/// generated `upiRef` on success.
class PaymentSheet extends ConsumerStatefulWidget {
  const PaymentSheet({
    super.key,
    required this.messId,
    required this.plan,
  });

  final String messId;
  final SubscriptionPlan plan;

  @override
  ConsumerState<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<PaymentSheet> {
  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveLayout.horizontalPadding(context);
    final theme = Theme.of(context);
    final flow = ref.watch(subscriptionFlowProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: padding,
        right: padding,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subscribe & Pay', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          _row('Plan', widget.plan.planName),
          _row('Meal', _title(widget.plan.mealType)),
          _row('Billing', _title(widget.plan.billingCycle)),
          _row('Amount', '₹${widget.plan.price.toStringAsFixed(0)}'),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'Simulated UPI — no real money moves.',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: flow.isLoading ? 'Processing...' : 'Pay ₹${widget.plan.price.toStringAsFixed(0)}',
              busy: flow.isLoading,
              onPressed: flow.isLoading ? null : _pay,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(value, style: theme.textTheme.titleSmall),
        ],
      ),
    );
  }

  String _title(String s) => s[0] + s.substring(1).toLowerCase();

  void _pay() async {
    try {
      final payment = await ref
          .read(subscriptionFlowProvider.notifier)
          .subscribe(
            messId: widget.messId,
            planName: widget.plan.planName,
            mealType: widget.plan.mealType,
            billingCycle: widget.plan.billingCycle,
            price: widget.plan.price,
          );
      if (!mounted) return;
      Navigator.pop(context);
      if (payment.isSuccess) {
        showSnackBar(
          context,
          'Payment successful! UPI Ref: ${payment.upiRef}',
        );
      } else {
        showErrorSnackBar(context, 'Payment failed');
      }
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    }
  }
}