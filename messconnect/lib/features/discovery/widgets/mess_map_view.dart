import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../models/mess.dart';

/// Google Maps view of discovery results (PART 6).
///
/// Centered on the placeholder college location from [AppConstants]; markers
/// are added for every mess with coordinates. Tapping a marker opens the
/// dedicated mess detail route. A real Maps API key is required for tiles to
/// render — set in AndroidManifest (verified in PART 11).
class MessMapView extends StatelessWidget {
  const MessMapView({super.key, required this.messes});

  final List<Mess> messes;

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>{
      for (final m in messes.where((m) => m.hasLocation))
        Marker(
          markerId: MarkerId(m.id),
          position: LatLng(m.latitude!, m.longitude!),
          infoWindow: InfoWindow(title: m.name),
          onTap: () => context.push('/home/mess/${m.id}'),
        ),
    };

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(AppConstants.mapDefaultLat, AppConstants.mapDefaultLng),
        zoom: AppConstants.mapDefaultZoom,
      ),
      markers: markers,
      myLocationEnabled: false,
      zoomControlsEnabled: true,
    );
  }
}
