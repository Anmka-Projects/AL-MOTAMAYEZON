import 'package:flutter/material.dart';

import 'video_playback_speed.dart';

/// Shows a modal bottom sheet to pick a playback speed.
///
/// Returns the selected speed, or `null` if dismissed without selection.
Future<double?> showVideoPlaybackSpeedSheet(
  BuildContext context, {
  required double currentSpeed,
}) {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;

  return showModalBottomSheet<double>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: cs.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Playback speed',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a speed for this video',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ...VideoPlaybackSpeed.supported.map((speed) {
                final selected = (currentSpeed - speed).abs() < 0.001;
                final label = VideoPlaybackSpeed.label(speed);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: selected
                        ? cs.primaryContainer.withOpacity(0.35)
                        : cs.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: selected ? cs.primary : Colors.transparent,
                          width: selected ? 2 : 0,
                        ),
                      ),
                      title: Text(
                        label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? cs.primary : cs.onSurface,
                        ),
                      ),
                      trailing: selected
                          ? Icon(Icons.check_circle, color: cs.primary)
                          : null,
                      onTap: () => Navigator.of(ctx).pop(speed),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}
