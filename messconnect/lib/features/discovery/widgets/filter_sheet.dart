import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../providers/mess_provider.dart';

/// Bottom-sheet for refining mess discovery (city / area / name / radius).
///
/// "Apply" writes the values into [messFilterProvider] (triggering a refetch
/// via [messesProvider]); "Clear" resets the filter.
class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key, required this.initial});

  final MessFilterState initial;

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  final _city = TextEditingController();
  final _area = TextEditingController();
  final _name = TextEditingController();
  final _radius = TextEditingController();

  @override
  void initState() {
    super.initState();
    _city.text = widget.initial.city ?? '';
    _area.text = widget.initial.area ?? '';
    _name.text = widget.initial.name ?? '';
    _radius.text = widget.initial.radiusKm?.toString() ?? '';
  }

  @override
  void dispose() {
    _city.dispose();
    _area.dispose();
    _name.dispose();
    _radius.dispose();
    super.dispose();
  }

  void _apply() {
    final radius = double.tryParse(_radius.text.trim());
    ref.read(messFilterProvider.notifier).state = MessFilterState(
      city: _city.text.trim(),
      area: _area.text.trim(),
      name: _name.text.trim(),
      radiusKm: radius,
    );
    Navigator.of(context).pop();
  }

  void _clear() {
    ref.read(messFilterProvider.notifier).state = const MessFilterState();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width < 360 ? 12.0 : 16.0;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          padding,
          16,
          padding,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Filters', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            AppTextField(controller: _name, label: 'Name'),
            AppTextField(controller: _city, label: 'City'),
            AppTextField(controller: _area, label: 'Area / locality'),
            AppTextField(
              controller: _radius,
              label: 'Radius (km)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            AppButton(label: 'Apply', onPressed: _apply),
            AppButton(
              label: 'Clear filters',
              onPressed: _clear,
            ),
          ],
        ),
      ),
    );
  }
}
