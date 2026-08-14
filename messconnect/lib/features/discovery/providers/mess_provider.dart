import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mess_repository.dart';
import '../models/mess.dart';

/// Immutable discovery filter. Empty by default → backend returns all messes.
class MessFilterState {
  const MessFilterState({
    this.name,
    this.city,
    this.area,
    this.radiusKm,
  });

  final String? name;
  final String? city;
  final String? area;
  final double? radiusKm;

  MessFilterState copyWith({
    String? name,
    String? city,
    String? area,
    double? radiusKm,
  }) {
    return MessFilterState(
      name: name,
      city: city,
      area: area,
      radiusKm: radiusKm,
    );
  }

  bool get isEmpty =>
      (name == null || name!.isEmpty) &&
      (city == null || city!.isEmpty) &&
      (area == null || area!.isEmpty) &&
      radiusKm == null;
}

/// Holds the active discovery filter; mutating it refetches [messesProvider].
final messFilterProvider =
    StateProvider<MessFilterState>((ref) => const MessFilterState());

/// Reactive list of messes for the current filter.
///
/// Watching [messFilterProvider] means any change (search submit, filter apply)
/// triggers a fresh `GET /api/messes`.
final messesProvider = FutureProvider<List<Mess>>((ref) async {
  final filter = ref.watch(messFilterProvider);
  try {
    return await ref.watch(messRepositoryProvider).search(
          name: filter.name,
          city: filter.city,
          area: filter.area,
          radiusKm: filter.radiusKm,
        );
  } catch (e) {
    logMessError(e);
    rethrow;
  }
});
