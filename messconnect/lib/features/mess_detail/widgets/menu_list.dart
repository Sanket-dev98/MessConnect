import 'package:flutter/material.dart';

import '../../../core/widgets/app_empty_state.dart';
import '../models/menu_item.dart';

/// Renders a mess's menu grouped by meal type (BREAKFAST → DINNER → SNACKS).
class MenuList extends StatelessWidget {
  const MenuList({super.key, required this.items});

  final List<MenuItem> items;

  static const _order = ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACKS'];

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const AppEmptyState(message: 'No menu available yet.');
    }
    final byType = <String, List<MenuItem>>{};
    for (final item in items) {
      byType.putIfAbsent(item.mealType, () => []).add(item);
    }
    final types = [
      ..._order.where(byType.containsKey),
      ...byType.keys.where((t) => !_order.contains(t)),
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: types.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, i) {
        final type = types[i];
        final group = byType[type]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _label(type),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...group.map((item) => _row(context, item)),
          ],
        );
      },
    );
  }

  Widget _row(BuildContext context, MenuItem item) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(item.itemName,
                        style: theme.textTheme.bodyLarge),
                    if (item.veg)
                      const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(Icons.eco, size: 14, color: Colors.green),
                      ),
                  ],
                ),
                if (item.description != null &&
                    item.description!.isNotEmpty)
                  Text(
                    item.description!,
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Text(
            '₹${item.price.toStringAsFixed(0)}',
            style: theme.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  String _label(String type) =>
      type[0] + type.substring(1).toLowerCase();
}
