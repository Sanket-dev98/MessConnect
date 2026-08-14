import 'package:flutter/material.dart';

/// Hero photo for a mess, sourced from [imageUrl] (the real `Mess.imageUrl`).
///
/// Falls back to a branded placeholder when there is no URL, and degrades
/// gracefully if the URL fails to load (no crash on a bad/placeholder URL).
class PhotoGallery extends StatelessWidget {
  const PhotoGallery({super.key, this.imageUrl, this.height = 200});

  final String? imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = imageUrl;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: url != null && url.isNotEmpty
          ? Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _placeholder(theme),
            )
          : _placeholder(theme),
    );
  }

  Widget _placeholder(ThemeData theme) {
    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: 64,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
