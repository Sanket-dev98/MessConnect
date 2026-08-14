import 'package:flutter/material.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../subscriptions/models/subscription_plan.dart';

/// Subscription plans offered by a mess (PART 7).
///
/// The "Subscribe" button is intentionally **non-wired** — actual subscription
/// creation + UPI payment lands in PART 9. It is shown enabled-looking but
/// triggers a "coming soon" snackbar so the UI is complete without faking a
/// backend call.
class PlanList extends StatelessWidget {
  const PlanList({super.key, required this.plans, this.onSubscribe});

  final List<SubscriptionPlan> plans;
  final void Function(SubscriptionPlan)? onSubscribe;

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) {
      return const AppEmptyState(message: 'No plans available yet.');
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: plans.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _card(context, plans[i]),
    );
  }

  Widget _card(BuildContext context, SubscriptionPlan plan) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.planName,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Text(
                  '₹${plan.price.toStringAsFixed(0)}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${_meal(plan.mealType)} · ${_cycle(plan.billingCycle)}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Subscribe',
                onPressed: onSubscribe == null
                    ? null
                    : () => onSubscribe!(plan),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _meal(String m) => m[0] + m.substring(1).toLowerCase();
  String _cycle(String c) => c[0] + c.substring(1).toLowerCase();
}
